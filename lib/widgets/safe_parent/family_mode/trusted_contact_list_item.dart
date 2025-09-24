import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class TrustedContactListItem extends StatelessWidget {
  final TrustedContact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSendMessage;

  const TrustedContactListItem({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      title: Text(
        contact.name,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        contact.phone,
        style: theme.textTheme.bodyMedium,
      ),
      leading: Icon(
        Icons.contact_phone,
        color: theme.colorScheme.primary,
        size: 28,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.send_to_mobile_outlined,
              color: theme.colorScheme.secondary,
            ),
            tooltip: 'Send "Call Me" SMS',
            onPressed: onSendMessage,
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: theme.colorScheme.secondary,
            ),
            tooltip: 'Edit Contact',
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: theme.colorScheme.error,
            ),
            tooltip: 'Delete Contact',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}