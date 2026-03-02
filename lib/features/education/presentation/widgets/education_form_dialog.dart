import 'package:flutter/material.dart';
import '../../domain/entities/education_entity.dart';

class EducationFormDialog extends StatefulWidget {
  final EducationEntity? education;

  const EducationFormDialog({super.key, this.education});

  @override
  State<EducationFormDialog> createState() => _EducationFormDialogState();
}

class _EducationFormDialogState extends State<EducationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _degreeController;
  late TextEditingController _institutionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _orderController;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(
      text: widget.education?.degree ?? '',
    );
    _institutionController = TextEditingController(
      text: widget.education?.institution ?? '',
    );
    _startDateController = TextEditingController(
      text: widget.education?.startDate ?? '',
    );
    _endDateController = TextEditingController(
      text: widget.education?.endDate ?? '',
    );
    _orderController = TextEditingController(
      text: widget.education?.orderIndex.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final edu = EducationEntity(
        id: widget.education?.id ?? '',
        degree: _degreeController.text,
        institution: _institutionController.text,
        startDate: _startDateController.text,
        endDate: _endDateController.text.isEmpty
            ? null
            : _endDateController.text,
        orderIndex: int.tryParse(_orderController.text) ?? 0,
      );
      Navigator.of(context).pop(edu);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.education == null ? 'Add Education' : 'Edit Education',
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
                  controller: _degreeController,
                  decoration: const InputDecoration(
                    labelText: 'Degree/Certificate',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _institutionController,
                  decoration: const InputDecoration(
                    labelText: 'Institution/University',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(
                    labelText: 'Start Date (e.g., Sep 2018)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(
                    labelText: 'End Date (Leave blank for Present)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _orderController,
                  decoration: const InputDecoration(
                    labelText: 'Order Index',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
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
