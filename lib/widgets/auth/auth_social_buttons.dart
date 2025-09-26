import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phishing_app/screens/main/home_screen.dart';

import '../../helpers/helpers.dart';
import '../../theme/theme.dart';
import '../widgets.dart';

class AuthSocialButtons extends StatefulWidget {
  const AuthSocialButtons({super.key});

  @override
  State<AuthSocialButtons> createState() => _AuthSocialButtonsState();
}

class _AuthSocialButtonsState extends State<AuthSocialButtons> {
  bool isLoading = false;

  void handleSocialLogin(String provider) {
    // ignore: avoid_print
    print('ESTE ES EL PUTOOOOOOOO PROVEDOR: $provider');
    HapticFeedback.lightImpact();
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {});

    setState(() {
      isLoading = false;
    });

    navigationWithoutAnimation(context, HomeScreen(initialIndex: 0));
  }

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
                onPressed: () => handleSocialLogin('google'),
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
                onPressed: () => handleSocialLogin('apple'),
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
                onPressed: () => handleSocialLogin('gitHub'),
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
