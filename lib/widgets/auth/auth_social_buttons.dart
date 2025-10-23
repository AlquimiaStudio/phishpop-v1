import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../../theme/theme.dart';
import '../widgets.dart';

class AuthSocialButtons extends StatefulWidget {
  const AuthSocialButtons({super.key});

  @override
  State<AuthSocialButtons> createState() => _AuthSocialButtonsState();
}

class _AuthSocialButtonsState extends State<AuthSocialButtons> {
  bool isLoading = false;

  Future<void> handleSocialLogin(String provider) async {
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);

    // Clear shared content IMMEDIATELY to prevent any auto-navigation
    final sharedContentProvider = Provider.of<SharedContentProvider>(
      context,
      listen: false,
    );
    sharedContentProvider.clearSharedContent();

    HapticFeedback.lightImpact();
    setState(() {
      isLoading = true;
    });

    try {
      bool success = false;

      switch (provider) {
        case 'google':
          success = await authProvider.signInWithGoogle();
          break;
        case 'apple':
          success = await authProvider.signInWithApple();
          break;
      }

      if (success && mounted) {
        // Navigate to home and remove all other routes
        // This forces AuthWrapper to rebuild and show the correct screen
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      // Los errores ya son manejados por el AuthProvider
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final socialButtons = <Widget>[
      Expanded(
        child: AuthSocialButton(
          icon: Icon(FontAwesomeIcons.google, color: Colors.red, size: 22),
          label: 'Google',
          onPressed: () => handleSocialLogin('google'),
          backgroundColor: Colors.white,
          isLoading: isLoading,
        ),
      ),

      if (Platform.isIOS) ...[
        const SizedBox(width: 14),
        Expanded(
          child: AuthSocialButton(
            icon: Icon(FontAwesomeIcons.apple, color: Colors.white, size: 22),
            label: 'Apple',
            onPressed: () => handleSocialLogin('apple'),
            backgroundColor: Colors.black,
            textColor: Colors.white,
            isLoading: isLoading,
          ),
        ),
      ],
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
        Platform.isIOS
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(children: socialButtons),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Row(children: socialButtons),
              ),
      ],
    );
  }
}
