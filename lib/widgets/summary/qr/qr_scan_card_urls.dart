import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/theme.dart';

class QrScanCardUrls extends StatelessWidget {
  final String qrUrl;
  final String destinationUrl;

  const QrScanCardUrls({
    super.key,
    required this.qrUrl,
    required this.destinationUrl,
  });

  void copyToClipboard(BuildContext context, String url, String type) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type URL copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  Widget _buildUrlSection({
    required BuildContext context,
    required String label,
    required String url,
    required String copyType,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.mediumText),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.mediumText,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => copyToClipboard(context, url, copyType),
              icon: Icon(Icons.copy, size: 18, color: AppColors.primaryColor),
              tooltip: 'Copy $copyType URL',
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            url,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUrlSection(
          context: context,
          label: 'QR Code URL',
          url: qrUrl,
          copyType: 'QR',
          icon: Icons.qr_code,
        ),
        const SizedBox(height: 16),
        _buildUrlSection(
          context: context,
          label: 'Destination URL',
          url: destinationUrl,
          copyType: 'Destination',
          icon: Icons.open_in_new,
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }
}
