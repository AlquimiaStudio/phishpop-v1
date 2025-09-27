import 'package:flutter/material.dart';

class ScanLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onScanPressed;
  final bool isLoading;

  const ScanLabel({
    super.key,
    required this.label,
    this.onScanPressed,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = isLoading ? 'Processing...' : label;

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
            : Icon(icon, size: 16),
        label: Text(
          displayText,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
