import 'package:flutter/material.dart';
import 'package:phishing_app/helpers/helpers.dart';

import '../models/models.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isAuthenticated = false;
  String? errorMessage;
  User? currentUser;
  String? token;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      errorMessage = emailValidation;
      isLoading = false;
      notifyListeners();
      return false;
    }

    final passwordValidation = Validators.validatePassword(password);
    if (passwordValidation != null) {
      errorMessage = passwordValidation;
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      await Future.delayed(const Duration(seconds: 2));

      currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@').first,
        createdAt: DateTime.now(),
      );

      token = 'fake_token_${DateTime.now().millisecondsSinceEpoch}';
      isAuthenticated = true;
      isLoading = false;

      notifyListeners();

      return true;
    } catch (e) {
      errorMessage = 'Authentication failed. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final nameValidation = Validators.validateName(name);
    if (nameValidation != null) {
      errorMessage = nameValidation;
      isLoading = false;
      notifyListeners();
      return false;
    }

    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      errorMessage = emailValidation;
      isLoading = false;
      notifyListeners();
      return false;
    }

    final passwordValidation = Validators.validatePassword(password);
    if (passwordValidation != null) {
      errorMessage = passwordValidation;
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      await Future.delayed(const Duration(seconds: 2));

      currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );
      token = 'fake_token_${DateTime.now().millisecondsSinceEpoch}';
      isAuthenticated = true;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Registration failed. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      currentUser = null;
      token = null;
      isAuthenticated = false;
      errorMessage = null;
      isLoading = false;

      notifyListeners();
    } catch (e) {
      errorMessage = 'Logout failed. Please try again.';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final hasStoredToken = token != null && token!.isNotEmpty;
      final hasStoredUser = currentUser != null;

      if (hasStoredToken && hasStoredUser) {
        isAuthenticated = true;
      } else {
        isAuthenticated = false;
        currentUser = null;
        token = null;
      }

      isLoading = false;
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      isAuthenticated = false;
      currentUser = null;
      token = null;
      errorMessage = 'Failed to check authentication status';
      isLoading = false;
      notifyListeners();
    }
  }
}
