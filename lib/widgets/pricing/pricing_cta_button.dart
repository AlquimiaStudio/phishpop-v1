import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../../services/services.dart';
import '../ui/ui.dart';

class PricingCTAButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const PricingCTAButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_open, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Start Premium Protection',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        const PricingRestoreButton(),
        const SizedBox(height: 24),
        Text(
          '30-day money-back guarantee',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.lightText),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PricingRestoreButton extends StatefulWidget {
  const PricingRestoreButton({super.key});

  @override
  State<PricingRestoreButton> createState() => _PricingRestoreButtonState();
}

class _PricingRestoreButtonState extends State<PricingRestoreButton> {
  bool _isRestoring = false;

  Future<void> _handleRestore() async {
    if (_isRestoring) return;

    setState(() => _isRestoring = true);

    try {
      final customerInfo = await RevenueCatService().restorePurchases();

      if (!mounted) return;

      if (customerInfo != null) {
        final isPremium =
            customerInfo
                .entitlements
                .all[RevenueCatService.entitlementId]
                ?.isActive ??
            false;

        if (isPremium) {
          GlobalSnackBar.showSuccess(
            context,
            'Purchase restored successfully! You now have access to Premium.',
          );
        } else {
          GlobalSnackBar.showInfo(
            context,
            'No previous purchases found to restore.',
          );
        }
      } else {
        GlobalSnackBar.showError(
          context,
          'Failed to restore purchases. Please try again.',
        );
      }
    } catch (e) {
      if (mounted) {
        GlobalSnackBar.showError(
          context,
          'An error occurred while restoring purchases.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRestoring = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isRestoring ? null : _handleRestore,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRestoring)
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              )
            else
              Icon(Icons.restore, size: 18, color: AppColors.primaryColor),
            const SizedBox(width: 8),
            Text(
              _isRestoring ? 'Restoring...' : 'Restore Purchase',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
