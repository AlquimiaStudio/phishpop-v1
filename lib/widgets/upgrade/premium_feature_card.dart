import 'package:flutter/material.dart';
import '../../helpers/helpers.dart';
import '../../screens/screens.dart';
import '../../theme/theme.dart';

class PremiumFeatureCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;

  const PremiumFeatureCard({
    super.key,
    this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.warningColor.withValues(alpha: 0.1),
              AppColors.warningColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.warningColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warningColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.workspace_premium,
                size: 40,
                color: AppColors.warningColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.warningColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  navigationWithoutAnimation(context, const PricingScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warningColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Upgrade to Premium',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
