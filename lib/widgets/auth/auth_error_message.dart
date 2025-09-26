import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class AuthErrorMessage extends StatelessWidget {
  final String errorMessage;

  const AuthErrorMessage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.dangerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.dangerColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.dangerColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.dangerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
