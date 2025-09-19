import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../helpers/helpers.dart';
import '../../../../theme/theme.dart';
import '../../../widgets.dart';

class ScanCardUrlMetadata extends StatelessWidget {
  final String time;
  final int processingTime;

  const ScanCardUrlMetadata({
    super.key,
    required this.time,
    required this.processingTime,
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
              child: ScanCardUrlMetadataItem(
                label: 'Scan Time',
                value: formatTimestamp(time),
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ScanCardUrlMetadataItem(
                label: 'Processing',
                value: '$processingTime ms',
                icon: Icons.timer,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}
