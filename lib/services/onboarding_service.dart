import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  // Onboarding keys
  static const String hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const String onboardingVersionKey = 'onboarding_version';
  static const int currentOnboardingVersion = 1;

  // Personalization keys
  static const String hasCompletedPersonalizationKey =
      'has_completed_personalization';
  static const String userTypeKey = 'user_type';

  // Onboarding methods
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

  // Personalization methods
  Future<bool> hasCompletedPersonalization() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasCompletedPersonalizationKey) ?? false;
  }

  Future<void> completePersonalization(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hasCompletedPersonalizationKey, true);
    await prefs.setString(userTypeKey, userType);
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTypeKey);
  }

  Future<void> resetPersonalization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(hasCompletedPersonalizationKey);
    await prefs.remove(userTypeKey);
  }
}
