import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../screens/screens.dart';

class ScamListItem extends StatelessWidget {
  final ScamScript scam;

  const ScamListItem({super.key, required this.scam});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.warning_amber,
          color: theme.colorScheme.error,
          size: 24,
        ),
      ),
      title: Text(
        scam.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${scam.redFlags.length} warning signs • ${scam.nextSteps.length} action steps',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ScamDetailScreen(scamScript: scam)),
        );
      },
    );
  }
}
