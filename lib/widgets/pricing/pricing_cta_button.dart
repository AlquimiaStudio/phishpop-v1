import 'package:flutter/material.dart';
import '../../theme/theme.dart';

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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        PricingRestoreButton(),
        const SizedBox(height: 8),
        Text(
          '30-day money-back guarantee',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.lightText,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PricingRestoreButton extends StatelessWidget {
  const PricingRestoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restoring purchase...'),
            backgroundColor: AppColors.infoColor,
          ),
        );
      },
      child: Text(
        'Restore Purchase',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}