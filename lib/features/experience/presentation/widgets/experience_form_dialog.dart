import 'package:flutter/material.dart';
import '../../domain/entities/experience_entity.dart';

class ExperienceFormDialog extends StatefulWidget {
  final ExperienceEntity? experience;

  const ExperienceFormDialog({super.key, this.experience});

  @override
  State<ExperienceFormDialog> createState() => _ExperienceFormDialogState();
}

class _ExperienceFormDialogState extends State<ExperienceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _roleController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(
      text: widget.experience?.companyText ?? '',
    );
    _roleController = TextEditingController(
      text: widget.experience?.role ?? '',
    );
    _startDateController = TextEditingController(
      text: widget.experience?.startDate ?? '',
    );
    _endDateController = TextEditingController(
      text: widget.experience?.endDate ?? '',
    );
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final exp = ExperienceEntity(
        id: widget.experience?.id ?? '',
        companyText: _companyController.text,
        role: _roleController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text.isEmpty
            ? null
            : _endDateController.text,
      );
      Navigator.of(context).pop(exp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.experience == null ? 'Add Experience' : 'Edit Experience',
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _companyController,
                  decoration: const InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, _startDateController),
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, _endDateController),
                  decoration: const InputDecoration(
                    labelText: 'End Date (Optional)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
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
