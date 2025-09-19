import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../../utils/utils.dart';

enum AuthState { idle, loading, error, success }

class EmailInputProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  bool showClearButton = false;
  bool isEmailValid = false;
  bool emailHasError = false;
  String? emailErrorMessage;

  String? emailValidation(String? value) {
    return validateEmail(value);
  }

  void onEmailchanged() {
    final emailText = emailController.text;
    showClearButton = emailText.isNotEmpty;

    final validationError = validateEmail(emailText);
    isEmailValid = validationError == null && emailText.isNotEmpty;
    emailHasError = validationError != null && emailText.isNotEmpty;
    emailErrorMessage = emailHasError ? validationError : null;

    notifyListeners();
  }

  OutlineInputBorder getBorder() {
    if (emailHasError) {
      return AppComponents.authErrorInputBorder;
    }
    if (isEmailValid) {
      return AppComponents.authFocusInputBorder;
    }
    return AppComponents.authInputBorder;
  }

  void clearEmail() {
    showClearButton = false;
    isEmailValid = false;
    emailHasError = false;
    emailErrorMessage = null;
    emailController.clear();
    notifyListeners();
  }
}
