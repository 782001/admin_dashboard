import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/project_entity.dart';
import '../cubit/projects_cubit.dart';

class ProjectFormDialog extends StatefulWidget {
  final ProjectEntity? project;

  const ProjectFormDialog({super.key, this.project});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _technologiesController;
  late TextEditingController _playStoreUrlController;
  late TextEditingController _githubUrlController;
  late TextEditingController _driveUrlController;
  late TextEditingController _orderIndexController;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _newImages = [];
  List<ProjectImageEntity> _existingImages = [];
  XFile? _logoFile;
  String? _currentLogoUrl;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _technologiesController = TextEditingController(
      text: p?.technologies.join(', ') ?? '',
    );
    _playStoreUrlController = TextEditingController(
      text: p?.playStoreUrl ?? '',
    );
    _githubUrlController = TextEditingController(text: p?.githubUrl ?? '');
    _driveUrlController = TextEditingController(text: p?.driveUrl ?? '');
    _orderIndexController = TextEditingController(
      text: p?.orderIndex.toString() ?? '0',
    );
    _existingImages = List.from(p?.images ?? []);
    _currentLogoUrl = p?.logoUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _playStoreUrlController.dispose();
    _githubUrlController.dispose();
    _driveUrlController.dispose();
    _orderIndexController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final logo = await _picker.pickImage(source: ImageSource.gallery);
    if (logo != null) {
      setState(() {
        _logoFile = logo;
      });
    }
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _newImages.addAll(images);
      });
    }
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    final img = _existingImages[index];
    context.read<ProjectsCubit>().deleteImage(img.id, img.imageUrl);
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final techs = _technologiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final cubit = context.read<ProjectsCubit>();

      // Handle logo upload if changed
      String? logoUrl = _currentLogoUrl;
      if (_logoFile != null) {
        final bytes = await _logoFile!.readAsBytes();
        logoUrl = await cubit.uploadLogo(_logoFile!.name, bytes);
      }

      // First add/update project to get ID
      ProjectEntity? currentProject;
      if (widget.project == null) {
        final newProject = ProjectEntity(
          id: '',
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          technologies: techs,
          playStoreUrl: _playStoreUrlController.text.trim().isEmpty
              ? null
              : _playStoreUrlController.text.trim(),
          githubUrl: _githubUrlController.text.trim().isEmpty
              ? null
              : _githubUrlController.text.trim(),
          driveUrl: _driveUrlController.text.trim().isEmpty
              ? null
              : _driveUrlController.text.trim(),
          logoUrl: logoUrl,
          orderIndex: int.tryParse(_orderIndexController.text) ?? 0,
        );
        currentProject = await cubit.addProjectAsync(newProject);
      } else {
        final updateProject = ProjectEntity(
          id: widget.project!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          technologies: techs,
          playStoreUrl: _playStoreUrlController.text.trim().isEmpty
              ? null
              : _playStoreUrlController.text.trim(),
          githubUrl: _githubUrlController.text.trim().isEmpty
              ? null
              : _githubUrlController.text.trim(),
          driveUrl: _driveUrlController.text.trim().isEmpty
              ? null
              : _driveUrlController.text.trim(),
          logoUrl: logoUrl,
          orderIndex: int.tryParse(_orderIndexController.text) ?? 0,
        );
        await cubit.updateProjectUseCase(updateProject);
        currentProject = updateProject;
      }

      // Now upload new images
      for (final xFile in _newImages) {
        final bytes = await xFile.readAsBytes();
        await cubit.uploadImage(currentProject.id, xFile.name, bytes);
      }
      cubit.loadProjects();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _pickLogo,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _logoFile != null
                            ? Image.network(_logoFile!.path, fit: BoxFit.cover)
                            : _currentLogoUrl != null
                            ? Image.network(_currentLogoUrl!, fit: BoxFit.cover)
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo, color: Colors.grey),
                                  Text(
                                    'Logo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          TextFormField(
                            controller: _orderIndexController,
                            decoration: const InputDecoration(
                              labelText: 'Order Index',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _technologiesController,
                  decoration: const InputDecoration(
                    labelText: 'Technologies (comma separated)',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _playStoreUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Play Store URL',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _githubUrlController,
                        decoration: const InputDecoration(
                          labelText: 'GitHub URL',
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _driveUrlController,
                  decoration: const InputDecoration(labelText: 'Drive URL'),
                ),
                const SizedBox(height: 24),
                Text('Images', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._existingImages.asMap().entries.map((entry) {
                      return Stack(
                        children: [
                          Image.network(
                            entry.value.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removeExistingImage(entry.key),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      );
                    }),
                    ..._newImages.asMap().entries.map((entry) {
                      return Stack(
                        children: [
                          // For web we use Image.network(entry.value.path) or specialized loader
                          Image.network(
                            entry.value.path,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removeNewImage(entry.key),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      );
                    }),
                    InkWell(
                      onTap: _pickImages,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
