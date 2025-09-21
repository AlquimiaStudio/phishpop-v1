import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../helpers/helpers.dart';
import '../../../theme/theme.dart';

class ScanCardHeader extends StatelessWidget {
  final String result;
  final String classification;
  final bool cached;

  const ScanCardHeader({
    super.key,
    required this.result,
    required this.classification,
    required this.cached,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: getCardColor(result).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            getCardIcon(result),
            color: getCardColor(result),
            size: 24,
          ),
        ).animate().scale(duration: 400.ms),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTextResultTitle(classification),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: getCardColor(result),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getTextResultSubtitle(classification),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),
        if (cached)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.infoColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cached, size: 14, color: AppColors.infoColor),
                const SizedBox(width: 4),
                Text(
                  'Cached',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.infoColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}
