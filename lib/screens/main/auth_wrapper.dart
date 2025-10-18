import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens.dart';
import '../../services/services.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const PersonalizationChecker();
        }

        return const OnboardingChecker();
      },
    );
  }
}

class OnboardingChecker extends StatelessWidget {
  const OnboardingChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingService = OnboardingService();

    return FutureBuilder<bool>(
      future: onboardingService.hasCompletedOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final hasCompletedOnboarding = snapshot.data ?? false;
        if (!hasCompletedOnboarding) {
          return const OnboardingScreen1();
        }

        return const AuthScreen();
      },
    );
  }
}

class PersonalizationChecker extends StatelessWidget {
  const PersonalizationChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingService = OnboardingService();

    return FutureBuilder<bool>(
      future: onboardingService.hasCompletedPersonalization(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final hasCompletedPersonalization = snapshot.data ?? false;
        if (!hasCompletedPersonalization) {
          return const PersonalizationScreen();
        }

        return const HomeScreen(initialIndex: 0);
      },
    );
  }
}
