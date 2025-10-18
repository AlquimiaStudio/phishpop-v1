import 'package:flutter/material.dart';
import '../../screens/screens.dart';
import '../../helpers/helpers.dart';

class PremiumUpgradeDialog extends StatelessWidget {
  final String featureName;
  final String description;
  final IconData icon;

  const PremiumUpgradeDialog({
    super.key,
    required this.featureName,
    this.description = 'This feature is available for Premium users only',
    this.icon = Icons.lock,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.95),
              Theme.of(context).primaryColor.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Premium Feature',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              featureName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.95),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withValues(alpha: 0.85),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  navigationWithoutAnimation(
                    context,
                    const PricingScreen(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade to Premium',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Maybe Later',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String featureName,
    String? description,
    IconData? icon,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PremiumUpgradeDialog(
        featureName: featureName,
        description: description ??
            'This feature is available for Premium users only',
        icon: icon ?? Icons.lock,
      ),
    );
  }
}
