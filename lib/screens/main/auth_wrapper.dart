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
          final user = snapshot.data!;

          // If user is anonymous (guest), show OnboardingChecker
          // which will eventually show AuthScreen
          if (user.isAnonymous) {
            return const OnboardingChecker();
          }

          // For authenticated users (non-guest), check personalization
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
    final currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder<bool>(
      future: onboardingService.hasCompletedOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final hasCompletedOnboarding = snapshot.data ?? false;

        // If user is anonymous (guest) and already authenticated,
        // they've implicitly completed onboarding by clicking "Continue as Guest"
        if (currentUser != null && currentUser.isAnonymous) {
          return const HomeScreen(initialIndex: 0);
        }

        // If onboarding not completed, show onboarding screens
        if (!hasCompletedOnboarding) {
          return const OnboardingScreen1();
        }

        // Onboarding completed but not authenticated, show AuthScreen
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
    final currentUser = FirebaseAuth.instance.currentUser;

    // If there's no user, go to onboarding
    if (currentUser == null) {
      return const OnboardingChecker();
    }

    // Guest users skip personalization and go directly to HomeScreen
    if (currentUser.isAnonymous) {
      return const HomeScreen(initialIndex: 0);
    }

    // For authenticated (non-guest) users, check if they completed personalization
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
