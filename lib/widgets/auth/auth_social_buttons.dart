import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/theme.dart';
import '../widgets.dart';

class AuthSocialButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onGitHubPressed;
  final bool isLoading;

  const AuthSocialButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onGitHubPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.lightText,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: AuthSocialButton(
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                  size: 22,
                ),
                label: 'Google',
                onPressed: onGooglePressed,
                backgroundColor: Colors.white,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AuthSocialButton(
                icon: Icon(
                  FontAwesomeIcons.apple,
                  color: Colors.white,
                  size: 22,
                ),
                label: 'Apple',
                onPressed: onApplePressed,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                isLoading: isLoading,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AuthSocialButton(
                icon: Icon(
                  FontAwesomeIcons.github,
                  color: Colors.white,
                  size: 22,
                ),
                label: 'GitHub',
                onPressed: onGitHubPressed,
                backgroundColor: const Color(0xFF24292e),
                textColor: Colors.white,
                isLoading: isLoading,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
