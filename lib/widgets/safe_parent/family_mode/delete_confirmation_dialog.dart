import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String contactName;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.contactName,
    required this.onConfirm,
  });

  static Future<bool> show(
    BuildContext context, 
    String contactName,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        contactName: contactName,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Contact'),
      content: Text('Are you sure you want to delete "$contactName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}