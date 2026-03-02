import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
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
  late TextEditingController _descriptionController;

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
      text: _formatDisplayDate(widget.experience?.startDate),
    );
    _endDateController = TextEditingController(
      text: _formatDisplayDate(widget.experience?.endDate),
    );
    _descriptionController = TextEditingController(
      text: widget.experience?.description ?? '',
    );
  }

  String _formatDisplayDate(String? date) {
    if (date == null || date.isEmpty) return '';
    // If it's already DD/MM/YYYY, return it
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(date)) return date;
    // If it's YYYY-MM-DD, convert to DD/MM/YYYY
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (_) {}
    return date;
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
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
        final d = picked.day.toString().padLeft(2, '0');
        final m = picked.month.toString().padLeft(2, '0');
        final y = picked.year.toString();
        controller.text = '$d/$m/$y';
      });
    }
  }

  String _toDbFormat(String displayDate) {
    if (displayDate.isEmpty) return '';
    final parts = displayDate.split('/');
    if (parts.length == 3) {
      // DD/MM/YYYY -> YYYY-MM-DD
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return displayDate;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final exp = ExperienceEntity(
        id: widget.experience?.id ?? '',
        companyText: _companyController.text.trim(),
        role: _roleController.text.trim(),
        startDate: _toDbFormat(_startDateController.text),
        endDate: _endDateController.text.isEmpty
            ? null
            : _toDbFormat(_endDateController.text),
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text.trim(),
      );
      Navigator.of(context).pop(exp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AlertDialog(
        title: Row(
          children: [
            Text(
              widget.experience == null ? 'Add Experience' : 'Edit Experience',
            ),
            const Spacer(),
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Write'),
                Tab(text: 'Preview'),
              ],
            ),
          ],
        ),
        content: SizedBox(
          width: 800,
          height: 600,
          child: TabBarView(
            children: [
              // Write Tab
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildField(
                        controller: _companyController,
                        label: 'Company',
                        icon: Icons.business,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildField(
                        controller: _roleController,
                        label: 'Job Role',
                        icon: Icons.work_outline,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildField(
                              controller: _startDateController,
                              label: 'Start Date (DD/MM/YYYY)',
                              icon: Icons.calendar_today,
                              readOnly: true,
                              onTap: () =>
                                  _selectDate(context, _startDateController),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildField(
                              controller: _endDateController,
                              label: 'End Date (Optional)',
                              icon: Icons.event_available,
                              readOnly: true,
                              onTap: () =>
                                  _selectDate(context, _endDateController),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 15,
                        decoration: InputDecoration(
                          labelText: 'Responsibilities & Achievements',
                          hintText:
                              'Use Markdown (- for bullets, ** for bold)...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(Icons.description_outlined),
                        ),
                        onChanged: (value) {
                          if (value.endsWith('\n')) {
                            final lines = value.split('\n');
                            if (lines.length >= 2) {
                              final lastLine = lines[lines.length - 2];
                              if (lastLine.isNotEmpty &&
                                  !lastLine.trim().startsWith('-')) {
                                lines[lines.length - 2] = '- $lastLine';
                              }
                            }
                            if (!lines.last.trim().startsWith('-')) {
                              lines[lines.length - 1] = '- ';
                            }

                            _descriptionController.text = lines.join('\n');
                            _descriptionController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                    offset: _descriptionController.text.length,
                                  ),
                                );
                          } else if (value.isEmpty) {
                            _descriptionController.text = '- ';
                            _descriptionController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                    offset: _descriptionController.text.length,
                                  ),
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Preview Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: MarkdownBody(
                  data: _descriptionController.text,
                  selectable: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: _submit, child: const Text('Save')),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
      ),
    );
  }
}
