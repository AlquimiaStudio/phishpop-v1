import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InfoHeaderMessage extends StatelessWidget {
  final String message;
  final Color? color;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const InfoHeaderMessage({
    super.key,
    required this.message,
    this.color,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = color ?? Theme.of(context).primaryColor;
    final icon = color != null ? Icons.warning_amber : Icons.info_outline;
    final showAction = onActionPressed != null && actionLabel != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: displayColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: displayColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: displayColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: displayColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (showAction) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: displayColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
