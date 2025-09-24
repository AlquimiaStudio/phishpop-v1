import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets.dart';

class ScamSafeResponseSection extends StatelessWidget {
  final String safeResponse;

  const ScamSafeResponseSection({super.key, required this.safeResponse});

  Future<void> _composeSms(
    BuildContext context,
    String message, [
    String? recipient,
  ]) async {
    final uriString = recipient != null
        ? 'sms:$recipient?body=${Uri.encodeComponent(message)}'
        : 'sms:?body=${Uri.encodeComponent(message)}';
    final uri = Uri.parse(uriString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS is not supported on this device'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeader(title: 'Safe Response'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            safeResponse,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(Icons.sms, color: theme.colorScheme.onPrimary),
            label: Text(
              'Send Safe Reply',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => _composeSms(context, safeResponse),
          ),
        ),
      ],
    );
  }
}
