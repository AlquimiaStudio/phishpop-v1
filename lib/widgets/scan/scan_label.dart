import 'package:flutter/material.dart';

class ScanLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onScanPressed;
  final bool isLoading;
  final bool isPremium;

  const ScanLabel({
    super.key,
    required this.label,
    this.onScanPressed,
    required this.icon,
    this.isLoading = false,
    this.isPremium = true,
  });

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (isLoading) {
      displayText = 'Processing...';
    } else if (!isPremium) {
      displayText = 'Premium';
    } else {
      displayText = label;
    }

    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onScanPressed,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : Icon(isPremium ? icon : Icons.lock, size: 16),
        label: Text(
          displayText,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPremium ? null : Colors.grey[400],
          foregroundColor: isPremium ? null : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: isPremium ? 4 : 1,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        ),
      ),
    );
  }
}
