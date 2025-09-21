import 'dart:math' as math;
import '../models/models.dart';

bool isValidWifiQR(String content) {
  return content.trim().toUpperCase().startsWith('WIFI:');
}

Map<String, String> parseWifiQR(String wifiContent) {
  final Map<String, String> data = {};
  
  final cleanContent = wifiContent.replaceFirst(RegExp(r'^WIFI:', caseSensitive: false), '');
  final parts = cleanContent.split(';');
  
  for (String part in parts) {
    if (part.contains(':')) {
      final keyValue = part.split(':');
      if (keyValue.length >= 2) {
        final key = keyValue[0].trim();
        final value = keyValue.sublist(1).join(':').trim();
        data[key] = value;
      }
    }
  }
  
  return data;
}

WifiSecurityType mapSecurityType(String type) {
  switch (type.toUpperCase()) {
    case 'WPA3':
      return WifiSecurityType.wpa3;
    case 'WPA2':
      return WifiSecurityType.wpa2;
    case 'WPA':
      return WifiSecurityType.wpa;
    case 'WEP':
      return WifiSecurityType.wep;
    case 'NOPASS':
    case '':
      return WifiSecurityType.open;
    default:
      return WifiSecurityType.wpa2;
  }
}

bool analyzeNetworkSecurity(String ssid, String password, WifiSecurityType securityType) {
  final suspiciousNames = ['free', 'bank', 'starbucks', 'mcdonalds', 'airport', 'hotel'];
  final lowerSSID = ssid.toLowerCase();
  
  if (suspiciousNames.any((name) => lowerSSID.contains(name))) {
    return false;
  }
  
  if (securityType == WifiSecurityType.open || securityType == WifiSecurityType.wep) {
    return false;
  }
  
  if (password.length < 8 || isWeakPassword(password)) {
    return false;
  }
  
  return true;
}

bool isWeakPassword(String password) {
  final weakPasswords = ['password', '12345678', 'admin', 'guest', 'wifi', 'starbucks', 'freewifi'];
  return weakPasswords.contains(password.toLowerCase());
}

WifiRiskLevel determineRiskLevel(String ssid, String password, WifiSecurityType securityType) {
  if (securityType == WifiSecurityType.open) return WifiRiskLevel.critical;
  if (securityType == WifiSecurityType.wep) return WifiRiskLevel.high;
  if (isWeakPassword(password)) return WifiRiskLevel.medium;
  if (securityType == WifiSecurityType.wpa3) return WifiRiskLevel.low;
  return WifiRiskLevel.low;
}

WifiClassification classifyNetwork(String ssid, String password, WifiSecurityType securityType) {
  if (securityType == WifiSecurityType.open) return WifiClassification.dangerous;
  if (securityType == WifiSecurityType.wep) return WifiClassification.insecure;
  if (isWeakPassword(password)) return WifiClassification.suspicious;
  return WifiClassification.safe;
}

double calculateSecurityScore(String password, WifiSecurityType securityType) {
  double score = 0.0;
  
  switch (securityType) {
    case WifiSecurityType.wpa3:
      score += 0.4;
      break;
    case WifiSecurityType.wpa2:
      score += 0.3;
      break;
    case WifiSecurityType.wpa:
      score += 0.2;
      break;
    case WifiSecurityType.wep:
      score += 0.1;
      break;
    case WifiSecurityType.open:
      score += 0.0;
      break;
    default:
      score += 0.3;
  }
  
  if (password.isEmpty) {
    score += 0.0;
  } else if (password.length >= 12 && hasComplexPassword(password)) {
    score += 0.6;
  } else if (password.length >= 8) {
    score += 0.4;
  } else {
    score += 0.2;
  }
  
  return math.min(1.0, score);
}

bool hasComplexPassword(String password) {
  final hasUpper = password.contains(RegExp(r'[A-Z]'));
  final hasLower = password.contains(RegExp(r'[a-z]'));
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  
  return hasUpper && hasLower && hasDigit && hasSpecial;
}

List<String> identifyIssues(String ssid, String password, WifiSecurityType securityType) {
  final List<String> issues = [];
  
  if (securityType == WifiSecurityType.open) {
    issues.add('Network is open without encryption');
    issues.add('All traffic can be intercepted');
  }
  
  if (securityType == WifiSecurityType.wep) {
    issues.add('WEP encryption is easily cracked');
    issues.add('Deprecated security protocol');
  }
  
  if (isWeakPassword(password)) {
    issues.add('Weak or common password detected');
  }
  
  if (password.length < 8 && password.isNotEmpty) {
    issues.add('Password is too short');
  }
  
  final suspiciousNames = ['free', 'bank', 'starbucks', 'mcdonalds'];
  if (suspiciousNames.any((name) => ssid.toLowerCase().contains(name))) {
    issues.add('Network name suggests potential honeypot');
    issues.add('May be impersonating legitimate service');
  }
  
  return issues;
}