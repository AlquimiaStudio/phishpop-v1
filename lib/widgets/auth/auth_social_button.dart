import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class AuthSocialButton extends StatelessWidget {
  final bool isLoading;
  final Color backgroundColor;
  final Color? textColor;
  final Icon icon;
  final String label;
  final VoidCallback? onPressed;

  const AuthSocialButton({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.isLoading,
    required this.label,
    this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: backgroundColor == Colors.white
                ? Border.all(color: Colors.grey[300]!)
                : null,
          ),
          child: Column(
            children: [
              icon,
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.smallButtonText.copyWith(
                  color: textColor ?? AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
