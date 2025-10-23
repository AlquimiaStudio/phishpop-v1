import 'package:flutter/material.dart';

import '../../theme/theme.dart';

/// Dialog shown when guest user is approaching their limit (2/3 scans used)
class GuestWarningDialog extends StatelessWidget {
  final int scansRemaining;

  const GuestWarningDialog({
    super.key,
    required this.scansRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Colors.orange.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Running Low on Scans',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You have $scansRemaining ${scansRemaining == 1 ? 'scan' : 'scans'} remaining this month',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a free account to get 7 scans per month instead of 3',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.mediumText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildBenefit(
              icon: Icons.flash_on,
              text: '7 scans per month (vs 3 for guests)',
            ),
            _buildBenefit(
              icon: Icons.history,
              text: 'Saved scan history',
            ),
            _buildBenefit(
              icon: Icons.bar_chart,
              text: 'Security statistics',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Free Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Continue as Guest',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.mediumText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required int scansRemaining,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => GuestWarningDialog(
        scansRemaining: scansRemaining,
      ),
    );
  }
}

/// Dialog shown when guest user has reached their limit (3/3 scans used)
class GuestLimitReachedDialog extends StatelessWidget {
  const GuestLimitReachedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.block,
                size: 48,
                color: Colors.red.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Guest Limit Reached',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You\'ve used all 3 scans this month',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a free account to continue scanning and unlock more features',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.mediumText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildBenefit(
              icon: Icons.flash_on,
              text: '7 scans per month',
              highlighted: true,
            ),
            _buildBenefit(
              icon: Icons.history,
              text: 'Complete scan history',
            ),
            _buildBenefit(
              icon: Icons.bar_chart,
              text: 'Detailed security statistics',
            ),
            _buildBenefit(
              icon: Icons.info_outline,
              text: 'Full technical analysis',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Create Free Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your limit resets next month',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.mediumText.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String text,
    bool highlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: highlighted ? AppColors.primaryColor : AppColors.primaryColor.withValues(alpha: 0.7),
            size: highlighted ? 22 : 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkText,
                fontWeight: highlighted ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> show({required BuildContext context}) {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must acknowledge
      builder: (context) => const GuestLimitReachedDialog(),
    );
  }
}
