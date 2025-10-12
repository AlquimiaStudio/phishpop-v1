import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens.dart';
import '../../services/services.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingService = OnboardingService();

    return FutureBuilder<bool>(
      future: onboardingService.hasCompletedOnboarding(),
      builder: (context, onboardingSnapshot) {
        if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final hasCompletedOnboarding = onboardingSnapshot.data ?? false;
        if (!hasCompletedOnboarding) {
          return const OnboardingScreen1();
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (authSnapshot.hasData && authSnapshot.data != null) {
              return const HomeScreen(initialIndex: 0);
            }
            return const AuthScreen();
          },
        );
      },
    );
  }
}
