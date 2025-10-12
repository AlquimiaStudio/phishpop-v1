import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const String hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const String onboardingVersionKey = 'onboarding_version';
  static const int currentOnboardingVersion = 1;

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(hasCompletedOnboardingKey) ?? false;
    final version = prefs.getInt(onboardingVersionKey) ?? 0;

    return completed && version >= currentOnboardingVersion;
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hasCompletedOnboardingKey, true);
    await prefs.setInt(onboardingVersionKey, currentOnboardingVersion);
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(hasCompletedOnboardingKey);
    await prefs.remove(onboardingVersionKey);
  }
}
