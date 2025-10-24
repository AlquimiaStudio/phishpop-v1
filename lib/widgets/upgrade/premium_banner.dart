import 'package:flutter/material.dart';
import '../../helpers/helpers.dart';
import '../../screens/screens.dart';
import '../../theme/theme.dart';

class PremiumBanner extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;

  const PremiumBanner({
    super.key,
    this.icon = Icons.auto_awesome,
    this.title = 'Unlock Full Protection',
    this.subtitle = 'Get power-AI scans and detailed analytics',
    this.buttonText = 'Upgrade',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.05),
            AppColors.warningColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warningColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 30, color: AppColors.warningColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              navigationWithoutAnimation(context, const PricingScreen());
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.warningColor.withValues(alpha: 0.1),
              foregroundColor: AppColors.warningColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
