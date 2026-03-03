import 'package:flutter/material.dart';
import '../../domain/entities/contact_entity.dart';

class ContactFormDialog extends StatefulWidget {
  final ContactEntity? contact;

  const ContactFormDialog({super.key, this.contact});

  @override
  State<ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends State<ContactFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _platformController;
  late TextEditingController _valueController;
  late TextEditingController _urlController;
  late TextEditingController _orderController;

  @override
  void initState() {
    super.initState();
    _platformController = TextEditingController(
      text: widget.contact?.platform ?? '',
    );
    _valueController = TextEditingController(text: widget.contact?.value ?? '');
    _urlController = TextEditingController(text: widget.contact?.url ?? '');
    _orderController = TextEditingController(
      text: widget.contact?.orderIndex.toString() ?? '0',
    );
  }

  @override
  void dispose() {
    _platformController.dispose();
    _valueController.dispose();
    _urlController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final contact = ContactEntity(
        id: widget.contact?.id ?? '',
        platform: _platformController.text,
        value: _valueController.text,
        url: _urlController.text.isEmpty ? null : _urlController.text,
        orderIndex: int.tryParse(_orderController.text) ?? 0,
      );
      Navigator.of(context).pop(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.contact == null ? 'Add Contact' : 'Edit Contact'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _platformController,
                  decoration: const InputDecoration(
                    labelText: 'Platform (e.g., Email, WhatsApp, GitHub)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valueController,
                  decoration: const InputDecoration(
                    labelText: 'Value (e.g., mail@example.com, +20...)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL (Action URL like mailto: or https://)',
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
