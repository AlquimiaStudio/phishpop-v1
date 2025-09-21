import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';
import '../../widgets.dart';

class ScanCardMetadata extends StatelessWidget {
  final String timestamp;
  final String scanType;
  final int processingTime;
  final double? normalizedScore;
  final String classification;

  const ScanCardMetadata({
    super.key,
    required this.timestamp,
    required this.processingTime,
    required this.scanType,
    required this.normalizedScore,
    required this.classification,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scan Details',
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
                label: 'Scan Time',
                value: formatTimestamp(timestamp),
                icon: Icons.schedule,
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: MetadataItem(
                label: 'Processing',
                value: '$processingTime ms',
                icon: Icons.timer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetadataItem(
                label: 'Scan Type',
                value: scanType,
                icon: Icons.category,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MetadataItem(
                label: 'Classification',
                value: classification.capitalize(),
                icon: Icons.label,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}
