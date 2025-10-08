import 'package:firebase_analytics/firebase_analytics.dart';

/// Service for tracking analytics events with Firebase Analytics
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Get the analytics observer for navigation tracking
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  // ==================== SCAN EVENTS ====================

  /// Log URL scan completion
  Future<void> logUrlScan({
    required String riskLevel,
    required String classification,
    required double confidenceScore,
  }) async {
    await _analytics.logEvent(
      name: 'scan_url',
      parameters: {
        'risk_level': riskLevel,
        'classification': classification,
        'confidence_score': confidenceScore.round(),
      },
    );
  }

  /// Log text/message scan completion
  Future<void> logTextScan({
    required String riskLevel,
    required String classification,
    required double confidenceScore,
  }) async {
    await _analytics.logEvent(
      name: 'scan_text',
      parameters: {
        'risk_level': riskLevel,
        'classification': classification,
        'confidence_score': confidenceScore.round(),
      },
    );
  }

  /// Log QR code scan completion
  Future<void> logQrScan({
    required String scanType, // 'url' or 'wifi'
    required String riskLevel,
  }) async {
    await _analytics.logEvent(
      name: 'scan_qr',
      parameters: {
        'scan_type': scanType,
        'risk_level': riskLevel,
      },
    );
  }

  /// Log when a threat is detected
  Future<void> logThreatDetected({
    required String threatType,
    required String scanType,
    required double confidenceScore,
  }) async {
    await _analytics.logEvent(
      name: 'threat_detected',
      parameters: {
        'threat_type': threatType,
        'scan_type': scanType,
        'confidence_score': confidenceScore.round(),
      },
    );
  }

  // ==================== USER ENGAGEMENT EVENTS ====================

  /// Log when user views scan history
  Future<void> logViewHistory() async {
    await _analytics.logEvent(name: 'view_history');
  }

  /// Log when user views statistics
  Future<void> logViewStats() async {
    await _analytics.logEvent(name: 'view_stats');
  }

  /// Log when user accesses Safe Parent features
  Future<void> logAccessSafeParent({required String feature}) async {
    await _analytics.logEvent(
      name: 'access_safe_parent',
      parameters: {'feature': feature},
    );
  }

  /// Log when user views scam library
  Future<void> logViewScamLibrary({required String scamType}) async {
    await _analytics.logEvent(
      name: 'view_scam_library',
      parameters: {'scam_type': scamType},
    );
  }

  /// Log when user adds trusted contact
  Future<void> logAddTrustedContact() async {
    await _analytics.logEvent(name: 'add_trusted_contact');
  }

  /// Log when user uses emergency call button
  Future<void> logEmergencyCall() async {
    await _analytics.logEvent(name: 'emergency_call');
  }

  // ==================== AUTHENTICATION EVENTS ====================

  /// Log user signup
  Future<void> logSignUp({required String method}) async {
    await _analytics.logEvent(
      name: 'sign_up',
      parameters: {'method': method}, // 'email', 'google', 'apple', 'github'
    );
  }

  /// Log user login
  Future<void> logLogin({required String method}) async {
    await _analytics.logEvent(
      name: 'login',
      parameters: {'method': method},
    );
  }

  /// Log user logout
  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
  }

  // ==================== SUBSCRIPTION EVENTS ====================

  /// Log when user views subscription options
  Future<void> logViewSubscription() async {
    await _analytics.logEvent(name: 'view_subscription');
  }

  /// Log when user starts a subscription
  Future<void> logSubscriptionStarted({
    required String packageId,
    required String price,
    required String period,
  }) async {
    await _analytics.logEvent(
      name: 'subscription_started',
      parameters: {
        'package_id': packageId,
        'price': price,
        'period': period, // 'monthly', 'annual'
      },
    );
  }

  /// Log when subscription purchase fails
  Future<void> logSubscriptionFailed({required String reason}) async {
    await _analytics.logEvent(
      name: 'subscription_failed',
      parameters: {'reason': reason},
    );
  }

  /// Log when user restores purchases
  Future<void> logRestorePurchases({required bool success}) async {
    await _analytics.logEvent(
      name: 'restore_purchases',
      parameters: {'success': success},
    );
  }

  // ==================== SHARING EVENTS ====================

  /// Log when user shares content to app
  Future<void> logSharedContentReceived({required String contentType}) async {
    await _analytics.logEvent(
      name: 'shared_content_received',
      parameters: {'content_type': contentType}, // 'url', 'text'
    );
  }

  // ==================== ERROR EVENTS ====================

  /// Log when an error occurs
  Future<void> logError({
    required String errorType,
    required String errorMessage,
  }) async {
    await _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
      },
    );
  }

  // ==================== USER PROPERTIES ====================

  /// Set user ID for analytics
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Set user property for subscription status
  Future<void> setSubscriptionStatus(bool isSubscribed) async {
    await _analytics.setUserProperty(
      name: 'subscription_status',
      value: isSubscribed ? 'premium' : 'free',
    );
  }

  /// Set total scans count as user property
  Future<void> setTotalScans(int totalScans) async {
    await _analytics.setUserProperty(
      name: 'total_scans',
      value: totalScans.toString(),
    );
  }
}
