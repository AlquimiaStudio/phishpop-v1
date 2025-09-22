import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../widgets.dart';

class ThreatsDetectedCard extends StatelessWidget {
  final Map<String, dynamic> threatsData;

  const ThreatsDetectedCard({super.key, required this.threatsData});

  @override
  Widget build(BuildContext context) {
    final count = threatsData['count'] as int;
    final percentage = threatsData['percentage'] as double;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatHeader(
            title: 'Threats',
            icon: Icons.warning,
            color: AppColors.dangerColor,
          ),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.dangerColor,
              fontWeight: FontWeight.bold,
              fontSize: 36,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${percentage.toStringAsFixed(1)}% of total scans',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.darkText.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
