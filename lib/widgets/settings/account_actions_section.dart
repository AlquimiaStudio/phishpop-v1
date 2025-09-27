import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../services/services.dart';
import '../../theme/theme.dart';

class AccountActionsSection extends StatelessWidget {
  const AccountActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appAuthProvider = context.read<AppAuthProvider>();

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
                  Icon(Icons.security, color: AppColors.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Account Actions',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (appAuthProvider.isEmailPasswordUser) ...[
                AccountActionButton(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () =>
                      AccountActionsService.handleChangePassword(context),
                  iconColor: AppColors.primaryColor,
                ),
                const SizedBox(height: 12),
              ],
              AccountActionButton(
                icon: Icons.logout,
                label: 'Sign Out',
                subtitle: 'Sign out from your account',
                onTap: () => AccountActionsService.handleSignOut(context),
                iconColor: Colors.orange,
              ),
              const SizedBox(height: 12),
              AccountActionButton(
                icon: Icons.delete_forever,
                label: 'Delete Account',
                subtitle: 'Permanently delete your account',
                onTap: () => AccountActionsService.handleDeleteAccount(context),
                iconColor: Colors.red,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(begin: 0.3, end: 0);
  }
}

class AccountActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;

  const AccountActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppColors.lightText, size: 16),
          ],
        ),
      ),
    );
  }
}
