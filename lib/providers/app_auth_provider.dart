import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:phishpop/helpers/helpers.dart';

import '../models/models.dart';
import '../services/services.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuthService authService = FirebaseAuthService();
  Timer? errorTimer;

  bool isLoading = false;
  bool isAuthenticated = false;
  String? errorMessage;
  User? currentUser;
  String? token;

  AppAuthProvider() {
    checkAuthStatus();
    authService.authStateChanges.listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser != null) {
        currentUser = User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name:
              firebaseUser.displayName ??
              firebaseUser.email?.split('@').first ??
              'User',
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        );
        token = firebaseUser.uid;
        isAuthenticated = true;
      } else {
        currentUser = null;
        token = null;
        isAuthenticated = false;
        errorMessage = null;
      }
      notifyListeners();
    });
  }

  bool get isEmailPasswordUser {
    final user = authService.currentUser;
    if (user == null) return false;

    return user.providerData.any((info) => info.providerId == 'password');
  }

  void setError(String error) {
    errorTimer?.cancel();
    errorMessage = error;
    notifyListeners();

    errorTimer = Timer(const Duration(seconds: 3), () {
      errorMessage = null;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      isLoading = false;
      setError(emailValidation);
      return false;
    }

    final passwordValidation = Validators.validatePassword(password);
    if (passwordValidation != null) {
      isLoading = false;
      setError(passwordValidation);
      return false;
    }

    try {
      final userCredential = await authService.signInWithEmail(email, password);

      if (userCredential?.user != null) {
        final firebaseUser = userCredential!.user!;
        currentUser = User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name:
              firebaseUser.displayName ??
              firebaseUser.email?.split('@').first ??
              'User',
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        );
        token = firebaseUser.uid;
        isAuthenticated = true;
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      setError(e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final nameValidation = Validators.validateName(name);
    if (nameValidation != null) {
      isLoading = false;
      setError(nameValidation);
      return false;
    }

    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      isLoading = false;
      setError(emailValidation);
      return false;
    }

    final passwordValidation = Validators.validatePassword(password);
    if (passwordValidation != null) {
      isLoading = false;
      setError(passwordValidation);
      return false;
    }

    try {
      final userCredential = await authService.registerWithEmail(
        email,
        password,
      );
      await authService.updateUserProfile(displayName: name);

      if (userCredential?.user != null) {
        final firebaseUser = userCredential!.user!;
        currentUser = User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: name,
          createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        );
        token = firebaseUser.uid;
        isAuthenticated = true;
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      setError(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await authService.signOut();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      setError(e.toString());
    }
  }

  Future<bool> signInWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await authService.signInWithGoogle();
      isLoading = false;
      notifyListeners();
      return credential != null;
    } catch (e) {
      isLoading = false;
      setError(e.toString());
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await authService.signInWithApple();
      isLoading = false;
      notifyListeners();
      return credential != null;
    } catch (e) {
      isLoading = false;
      setError(e.toString());
      return false;
    }
  }

  Future<bool> signInWithGitHub() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await authService.signInWithGitHub();
      isLoading = false;
      notifyListeners();
      return credential != null;
    } catch (e) {
      isLoading = false;
      setError(e.toString());
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await authService.deleteAccount();
      currentUser = null;
      token = null;
      isAuthenticated = false;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      setError(e.toString());
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await authService.sendPasswordResetEmail(email);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      setError(e.toString());
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    isLoading = true;
    notifyListeners();

    try {
      final firebaseUser = authService.currentUser;

      if (firebaseUser != null) {
        try {
          await firebaseUser.getIdToken(true);

          currentUser = User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name:
                firebaseUser.displayName ??
                firebaseUser.email?.split('@').first ??
                'User',
            createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
          );
          token = firebaseUser.uid;
          isAuthenticated = true;
        } catch (e) {
          await authService.signOut();
          currentUser = null;
          token = null;
          isAuthenticated = false;
        }
      } else {
        currentUser = null;
        token = null;
        isAuthenticated = false;
      }

      isLoading = false;
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      isAuthenticated = false;
      currentUser = null;
      token = null;
      isLoading = false;
      setError('Failed to check authentication status');
    }
  }
}
