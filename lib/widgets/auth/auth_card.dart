import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets.dart';

enum AuthMode { login, register }

enum AuthState { idle, loading, error, success }

class AuthCard extends StatefulWidget {
  final Animation<double> fadeAnimation;

  const AuthCard({super.key, required this.fadeAnimation});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode authMode = AuthMode.login;
  AuthState authState = AuthState.idle;
  String? errorMessage;

  void handleModeChanged(AuthMode mode) {
    if (authState == AuthState.loading) return;

    setState(() {
      authMode = mode;
      errorMessage = null;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: FadeTransition(
        opacity: widget.fadeAnimation,
        child: Card(
          elevation: 16,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthToggle(
                  currentMode: authMode,
                  onModeChanged: handleModeChanged,
                ),
                const SizedBox(height: 32),

                authMode == AuthMode.login
                    ? const AuthLoginForm()
                    : const AuthRegisterForm(),

                const SizedBox(height: 32),
                AuthSocialButtons(),
                const SizedBox(height: 24),
                const GuestModeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
