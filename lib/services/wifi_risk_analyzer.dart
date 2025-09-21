import 'dart:math' as math;
import '../models/models.dart';

abstract class IRiskAnalyzer {
  double calculateRiskPercentage(WifiClassification classification);
  List<String> generateFlaggedIssues(
    String ssid,
    String password,
    WifiSecurityType securityType,
    WifiClassification classification,
  );
  double generateConfidenceScore();
}

class WifiRiskAnalyzer implements IRiskAnalyzer {
  final math.Random _random = math.Random();

  @override
  double calculateRiskPercentage(WifiClassification classification) {
    switch (classification) {
      case WifiClassification.safe:
        return 5 + (_random.nextDouble() * 20); // 5%-25%
      case WifiClassification.suspicious:
        return 26 + (_random.nextDouble() * 49); // 26%-75%
      case WifiClassification.unsafe:
        return 76 + (_random.nextDouble() * 24); // 76%-100%
    }
  }

  @override
  List<String> generateFlaggedIssues(
    String ssid,
    String password,
    WifiSecurityType securityType,
    WifiClassification classification,
  ) {
    final List<String> issues = [];

    issues.addAll(_getSecurityTypeIssues(securityType));
    issues.addAll(_getPasswordIssues(password));
    issues.addAll(_getNetworkNameIssues(ssid));
    issues.addAll(_getClassificationSpecificIssues(classification, securityType));

    return issues;
  }

  @override
  double generateConfidenceScore() {
    return 0.85 + (_random.nextDouble() * 0.15); // 85%-100%
  }

  List<String> _getSecurityTypeIssues(WifiSecurityType securityType) {
    final List<String> issues = [];

    switch (securityType) {
      case WifiSecurityType.open:
        issues.addAll([
          'Network is open without encryption',
          'All traffic can be intercepted',
          'No authentication required',
          'Vulnerable to man-in-the-middle attacks',
        ]);
        break;
      case WifiSecurityType.wep:
        issues.addAll([
          'WEP encryption is easily cracked',
          'Deprecated security protocol',
          'Vulnerable to packet injection attacks',
          'Keys can be recovered within minutes',
        ]);
        break;
      case WifiSecurityType.wpa:
        issues.addAll([
          'WPA has known vulnerabilities',
          'Susceptible to dictionary attacks',
        ]);
        break;
      case WifiSecurityType.wpa2:
        break;
      case WifiSecurityType.wpa3:
        break;
      case WifiSecurityType.unknown:
        issues.add('Unknown security type detected');
        break;
    }

    return issues;
  }

  List<String> _getPasswordIssues(String password) {
    final List<String> issues = [];

    if (password.isEmpty) {
      issues.add('No password protection');
      return issues;
    }

    if (password.length < 8) {
      issues.add('Password is too short (less than 8 characters)');
    }

    if (_isWeakPassword(password)) {
      issues.add('Weak or common password detected');
    }

    if (!_hasComplexPassword(password)) {
      issues.add('Password lacks complexity');
    }

    if (password.length < 12) {
      issues.add('Password could be stronger (recommended 12+ characters)');
    }

    return issues;
  }

  List<String> _getNetworkNameIssues(String ssid) {
    final List<String> issues = [];
    final lowerSSID = ssid.toLowerCase();

    final suspiciousNames = [
      'free', 'wifi', 'internet', 'guest', 'public',
      'bank', 'starbucks', 'mcdonalds', 'airport', 'hotel',
      'apple', 'google', 'microsoft', 'amazon', 'facebook',
    ];

    final honeypotIndicators = [
      'freewifi', 'openwifi', 'publicwifi', 'guestwifi',
      'hotelwifi', 'airportwifi', 'coffeeshop',
    ];

    for (final name in suspiciousNames) {
      if (lowerSSID.contains(name)) {
        issues.add('Network name suggests potential honeypot: "$name"');
        issues.add('May be impersonating legitimate service');
        break;
      }
    }

    for (final indicator in honeypotIndicators) {
      if (lowerSSID.contains(indicator)) {
        issues.add('High probability honeypot network');
        issues.add('Designed to capture user credentials');
        break;
      }
    }

    if (ssid.length < 3) {
      issues.add('Unusually short network name');
    }

    if (RegExp(r'^[0-9]+$').hasMatch(ssid)) {
      issues.add('Network name is only numbers (suspicious)');
    }

    return issues;
  }

  List<String> _getClassificationSpecificIssues(
    WifiClassification classification,
    WifiSecurityType securityType,
  ) {
    final List<String> issues = [];

    switch (classification) {
      case WifiClassification.unsafe:
        issues.addAll([
          'CRITICAL: High risk of data theft',
          'CRITICAL: Avoid connecting sensitive devices',
          'CRITICAL: All traffic may be monitored',
          'Immediate security threat detected',
        ]);
        break;
      case WifiClassification.suspicious:
        issues.addAll([
          'WARNING: Security vulnerabilities present',
          'CAUTION: Potential security concerns',
          'Monitor for unusual network behavior',
          'Consider using VPN if connecting',
        ]);
        break;
      case WifiClassification.safe:
        if (securityType != WifiSecurityType.wpa3) {
          issues.add('Consider upgrading to WPA3 for enhanced security');
        }
        break;
    }

    return issues;
  }

  bool _isWeakPassword(String password) {
    final weakPasswords = [
      'password', '12345678', 'admin', 'guest', 'wifi',
      'starbucks', 'freewifi', 'internet', 'welcome',
      'qwerty', 'abc123', 'password123', '11111111',
    ];
    return weakPasswords.contains(password.toLowerCase());
  }

  bool _hasComplexPassword(String password) {
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUpper && hasLower && hasDigit && hasSpecial;
  }
}