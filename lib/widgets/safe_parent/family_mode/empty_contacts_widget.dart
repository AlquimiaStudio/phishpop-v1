import 'package:flutter/material.dart';

class EmptyContactsWidget extends StatelessWidget {
  const EmptyContactsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        'No trusted contacts added.\nTap the + button to add one.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}