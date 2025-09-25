import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/theme.dart';

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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.successColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Safe Response',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.successColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.successColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              safeResponse,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.darkText,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _composeSms(context, safeResponse),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sms, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Send Safe Reply',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
