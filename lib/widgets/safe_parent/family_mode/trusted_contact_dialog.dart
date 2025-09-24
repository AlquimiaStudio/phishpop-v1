import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class TrustedContactDialog extends StatefulWidget {
  final TrustedContact? contact;
  final Function(TrustedContact) onSave;
  final int? maxContacts;
  final int? currentCount;

  const TrustedContactDialog({
    super.key,
    this.contact,
    required this.onSave,
    this.maxContacts,
    this.currentCount,
  });

  @override
  State<TrustedContactDialog> createState() => _TrustedContactDialogState();
}

class _TrustedContactDialogState extends State<TrustedContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Check max contacts limit only for new contacts
      if (widget.contact == null && 
          widget.maxContacts != null && 
          widget.currentCount != null &&
          widget.currentCount! >= widget.maxContacts!) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maximum of ${widget.maxContacts} trusted contacts allowed.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final newContact = TrustedContact(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      
      widget.onSave(newContact);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Trusted Contact' : 'Add Trusted Contact'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) =>
                  value == null || value.trim().isEmpty 
                      ? 'Please enter a name' 
                      : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value == null || value.trim().isEmpty 
                      ? 'Please enter a phone number' 
                      : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}