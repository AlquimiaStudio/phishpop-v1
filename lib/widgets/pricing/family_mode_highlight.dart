import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../helpers/helpers.dart';

class FamilyModeHighlight extends StatelessWidget {
  const FamilyModeHighlight({super.key});

  @override
  Widget build(BuildContext context) {
    final familyFeatures = getFamilyModeFeatures();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondaryColor.withValues(alpha: 0.1),
            AppColors.primaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.secondaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.family_restroom,
                  color: AppColors.secondaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Family Mode Features',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Text(
                      'Designed for elderly protection',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mediumText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...familyFeatures.map(
            (feature) => FamilyFeatureItem(
              icon: feature['icon'] as IconData,
              title: feature['title'] as String,
            ),
          ),
        ],
      ),
    );
  }
}

class FamilyFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const FamilyFeatureItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
