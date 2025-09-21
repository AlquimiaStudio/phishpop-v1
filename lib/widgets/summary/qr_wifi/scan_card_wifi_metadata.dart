import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanCardWifiMetadata extends StatelessWidget {
  final String scanType;
  final String classification;
  final String time;
  final int processingTime;

  const ScanCardWifiMetadata({
    super.key,
    required this.scanType,
    required this.classification,
    required this.time,
    required this.processingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Details',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.mediumText,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetadataItem(
                label: 'Scan Type',
                value: scanType,
                icon: Icons.qr_code_scanner,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetadataItem(
                label: 'Classification',
                value: classification.capitalize(),
                icon: Icons.category,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetadataItem(
                label: 'Scan Time',
                value: formatTimestamp(time),
                icon: Icons.access_time,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetadataItem(
                label: 'Processing',
                value: '${processingTime}ms',
                icon: Icons.speed,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}
