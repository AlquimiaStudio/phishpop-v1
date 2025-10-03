import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../helpers/helpers.dart';

class PricingFeatures extends StatelessWidget {
  const PricingFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final features = getPremiumFeatures();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.darkText,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map(
          (feature) => PricingFeatureItem(
            icon: feature['icon'] as IconData,
            title: feature['title'] as String,
            description: feature['description'] as String,
          ),
        ),
      ],
    );
  }
}

class PricingFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PricingFeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.successColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.mediumText),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: AppColors.successColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}
