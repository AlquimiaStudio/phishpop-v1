import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';

class ConfidenceScoreBar extends StatelessWidget {
  final String result;
  final double confidenceScore;

  final String Function(String) getDescription;

  const ConfidenceScoreBar({
    super.key,
    required this.confidenceScore,
    required this.result,
    required this.getDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confidence',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.mediumText,
              ),
            ),
            Text(
              '${(confidenceScore * 100).round()}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: getCardColor(result),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: getCardColor(result).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidenceScore,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(getCardColor(result)),
            ).animate().scaleX(duration: 800.ms, curve: Curves.easeOutCubic),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          getDescription(result),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}
