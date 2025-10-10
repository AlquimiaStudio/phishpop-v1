import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../helpers/helpers.dart';
import 'scan_database_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseHelpers.handleFirebaseError(e);
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Sign in failed for: $email',
      );
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<UserCredential?> registerWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseHelpers.handleFirebaseError(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _auth.currentUser?.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
    } catch (e) {
      throw 'Failed to update profile. Please try again.';
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw 'Google sign-in failed. Please try again.';
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = FirebaseHelpers.generateNonce();
      final nonce = FirebaseHelpers.sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: kIsWeb
            ? WebAuthenticationOptions(
                clientId: 'com.andressaumet.phishpop.signin',
                redirectUri: Uri.parse(
                  'https://phishpop-app.firebaseapp.com/__/auth/handler',
                ),
              )
            : null,
      );

      if (appleCredential.identityToken == null) {
        throw 'Apple sign-in failed: No identity token received';
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);

      if (appleCredential.givenName != null &&
          appleCredential.familyName != null) {
        final displayName =
            '${appleCredential.givenName} ${appleCredential.familyName}';
        await userCredential.user?.updateDisplayName(displayName);
      }

      return userCredential;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return null;
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Apple Sign In Authorization Error: ${e.code}',
      );

      throw 'Apple sign-in failed: ${e.message}';
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Apple Sign In failed',
      );

      throw 'Apple sign-in failed: $e';
    }
  }

  Future<UserCredential?> signInWithGitHub() async {
    try {
      final githubProvider = OAuthProvider("github.com");

      githubProvider.addScope('user:email');
      githubProvider.addScope('read:user');

      final userCredential = await _auth.signInWithProvider(githubProvider);

      return userCredential;
    } catch (e) {
      throw 'GitHub sign-in failed. Please try again.';
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw 'Sign out failed. Please try again.';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseHelpers.handleFirebaseError(e);
    } catch (e) {
      throw 'Failed to send password reset email. Please try again.';
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Save user reference before any operations
      final user = _auth.currentUser;

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      final scanDatabaseService = ScanDatabaseService();
      await scanDatabaseService.clearAllScans();

      await deleteSQLiteDatabase();

      if (user != null) {
        await user.delete();
        await signOut();
      } else {
        await signOut();
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseHelpers.handleFirebaseError(e);
    } catch (e) {
      throw 'Failed to delete account. Please try again.';
    }
  }

  Future<void> deleteSQLiteDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'app_database.db');
      await deleteDatabase(path);
    } catch (e) {
      // Database might not exist, ignore error
    }
  }
}
