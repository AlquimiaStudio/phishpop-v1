import 'package:flutter/material.dart';

import '../widgets.dart';

class AuthToggle extends StatelessWidget {
  final AuthMode currentMode;
  final ValueChanged<AuthMode> onModeChanged;

  const AuthToggle({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: AuthToggleButton(
              text: 'Login',
              isSelected: currentMode == AuthMode.login,
              onTap: () => onModeChanged(AuthMode.login),
            ),
          ),
          Expanded(
            child: AuthToggleButton(
              text: 'Register',
              isSelected: currentMode == AuthMode.register,
              onTap: () => onModeChanged(AuthMode.register),
            ),
          ),
        ],
      ),
    );
  }
}
