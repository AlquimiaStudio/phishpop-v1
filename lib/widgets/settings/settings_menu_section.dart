import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/theme.dart';
import 'settings_menu_item.dart';

class SettingsMenuSection extends StatelessWidget {
  const SettingsMenuSection({super.key});

  void handlePrivacySecurity(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy & Security settings coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void handleAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primaryColor, size: 24),
              const SizedBox(width: 8),
              const Text('About PhishPop'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PhishPop is a security app designed to protect you from phishing attacks and malicious content.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: 14, color: AppColors.lightText),
              ),
              const SizedBox(height: 8),
              Text(
                'Developed by: Alquimia Studio',
                style: TextStyle(fontSize: 14, color: AppColors.lightText),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.tune, color: AppColors.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'App Settings',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SettingsMenuItem(
                icon: Icons.shield_outlined,
                title: 'Privacy & Security',
                subtitle: 'Manage your privacy settings',
                onTap: () => handlePrivacySecurity(context),
                iconColor: Colors.green,
              ),
              const SizedBox(height: 12),
              SettingsMenuItem(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () => handleAbout(context),
                iconColor: Colors.blue,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }
}
