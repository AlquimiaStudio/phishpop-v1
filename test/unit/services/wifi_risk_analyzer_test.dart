import 'package:flutter_test/flutter_test.dart';
import 'package:phishpop/models/qr_wifi_response_model.dart';
import 'package:phishpop/services/wifi_risk_analyzer.dart';

void main() {
  late WifiRiskAnalyzer analyzer;

  setUp(() {
    analyzer = WifiRiskAnalyzer();
  });

  group('WifiRiskAnalyzer - Risk Percentage Calculation', () {
    test('should return risk between 5-25% for safe networks', () {
      for (int i = 0; i < 10; i++) {
        final risk = analyzer.calculateRiskPercentage(WifiClassification.safe);
        expect(risk, greaterThanOrEqualTo(5));
        expect(risk, lessThanOrEqualTo(25));
      }
    });

    test('should return risk between 26-75% for suspicious networks', () {
      for (int i = 0; i < 10; i++) {
        final risk = analyzer.calculateRiskPercentage(WifiClassification.suspicious);
        expect(risk, greaterThanOrEqualTo(26));
        expect(risk, lessThanOrEqualTo(75));
      }
    });

    test('should return risk between 76-100% for unsafe networks', () {
      for (int i = 0; i < 10; i++) {
        final risk = analyzer.calculateRiskPercentage(WifiClassification.unsafe);
        expect(risk, greaterThanOrEqualTo(76));
        expect(risk, lessThanOrEqualTo(100));
      }
    });
  });

  group('WifiRiskAnalyzer - Confidence Score', () {
    test('should return confidence score between 85-100%', () {
      for (int i = 0; i < 10; i++) {
        final confidence = analyzer.generateConfidenceScore();
        expect(confidence, greaterThanOrEqualTo(0.85));
        expect(confidence, lessThanOrEqualTo(1.0));
      }
    });
  });

  group('WifiRiskAnalyzer - Security Type Issues', () {
    test('should flag open networks with multiple security issues', () {
      final issues = analyzer.generateFlaggedIssues(
        'TestNetwork',
        '',
        WifiSecurityType.open,
        WifiClassification.unsafe,
      );

      expect(issues, contains('Network is open without encryption'));
      expect(issues, contains('All traffic can be intercepted'));
      expect(issues, contains('No authentication required'));
      expect(issues, contains('Vulnerable to man-in-the-middle attacks'));
    });

    test('should flag WEP networks as deprecated', () {
      final issues = analyzer.generateFlaggedIssues(
        'OldRouter',
        'password',
        WifiSecurityType.wep,
        WifiClassification.unsafe,
      );

      expect(issues, contains('WEP encryption is easily cracked'));
      expect(issues, contains('Deprecated security protocol'));
      expect(issues, contains('Vulnerable to packet injection attacks'));
    });

    test('should flag WPA networks with known vulnerabilities', () {
      final issues = analyzer.generateFlaggedIssues(
        'LegacyWiFi',
        'password123',
        WifiSecurityType.wpa,
        WifiClassification.suspicious,
      );

      expect(issues, contains('WPA has known vulnerabilities'));
      expect(issues, contains('Susceptible to dictionary attacks'));
    });

    test('should not flag WPA2 with strong password as insecure', () {
      final issues = analyzer.generateFlaggedIssues(
        'MyHomeNetwork',
        'Str0ng!P@ssw0rd123',
        WifiSecurityType.wpa2,
        WifiClassification.safe,
      );

      expect(issues, isNot(contains('WPA has known vulnerabilities')));
      expect(issues, isNot(contains('WEP encryption is easily cracked')));
    });

    test('should handle unknown security type', () {
      final issues = analyzer.generateFlaggedIssues(
        'UnknownNet',
        'password',
        WifiSecurityType.unknown,
        WifiClassification.suspicious,
      );

      expect(issues, contains('Unknown security type detected'));
    });
  });

  group('WifiRiskAnalyzer - Password Issues', () {
    test('should flag networks without password', () {
      final issues = analyzer.generateFlaggedIssues(
        'OpenWiFi',
        '',
        WifiSecurityType.open,
        WifiClassification.unsafe,
      );

      expect(issues, contains('No password protection'));
    });

    test('should flag short passwords', () {
      final issues = analyzer.generateFlaggedIssues(
        'TestNet',
        'short',
        WifiSecurityType.wpa2,
        WifiClassification.suspicious,
      );

      expect(issues, contains('Password is too short (less than 8 characters)'));
    });

    test('should flag weak/common passwords', () {
      final weakPasswords = ['password', '12345678', 'admin', 'guest', 'wifi'];

      for (final password in weakPasswords) {
        final issues = analyzer.generateFlaggedIssues(
          'TestNet',
          password,
          WifiSecurityType.wpa2,
          WifiClassification.suspicious,
        );

        expect(issues, contains('Weak or common password detected'),
            reason: 'Failed for password: $password');
      }
    });

    test('should flag passwords lacking complexity', () {
      final issues = analyzer.generateFlaggedIssues(
        'TestNet',
        'simplepwd',
        WifiSecurityType.wpa2,
        WifiClassification.suspicious,
      );

      expect(issues, contains('Password lacks complexity'));
    });

    test('should recommend longer passwords', () {
      final issues = analyzer.generateFlaggedIssues(
        'TestNet',
        'Pass123',
        WifiSecurityType.wpa2,
        WifiClassification.safe,
      );

      expect(issues, contains('Password could be stronger (recommended 12+ characters)'));
    });

    test('should not flag strong complex passwords', () {
      final issues = analyzer.generateFlaggedIssues(
        'SecureNetwork',
        'C0mpl3x!P@ssw0rd12345',
        WifiSecurityType.wpa3,
        WifiClassification.safe,
      );

      expect(issues, isNot(contains('Password lacks complexity')));
      expect(issues, isNot(contains('Weak or common password detected')));
      expect(issues, isNot(contains('Password is too short')));
    });
  });

  group('WifiRiskAnalyzer - Network Name Issues', () {
    test('should flag potential honeypot networks', () {
      final honeypotNames = [
        'FreeWiFi',
        'PublicWiFi',
        'GuestWiFi',
        'HotelWiFi',
        'AirportWiFi',
      ];

      for (final ssid in honeypotNames) {
        final issues = analyzer.generateFlaggedIssues(
          ssid,
          '',
          WifiSecurityType.open,
          WifiClassification.unsafe,
        );

        expect(issues.any((issue) => issue.contains('honeypot')), isTrue,
            reason: 'Failed for SSID: $ssid');
      }
    });

    test('should flag networks impersonating legitimate services', () {
      final suspiciousNames = [
        'Starbucks_WiFi',
        'McDonalds_Free',
        'Apple_Guest',
        'Google_Public',
      ];

      for (final ssid in suspiciousNames) {
        final issues = analyzer.generateFlaggedIssues(
          ssid,
          '',
          WifiSecurityType.open,
          WifiClassification.unsafe,
        );

        expect(
          issues.any((issue) =>
            issue.contains('potential honeypot') ||
            issue.contains('impersonating legitimate service')
          ),
          isTrue,
          reason: 'Failed for SSID: $ssid',
        );
      }
    });

    test('should flag unusually short network names', () {
      final issues = analyzer.generateFlaggedIssues(
        'AB',
        'password',
        WifiSecurityType.wpa2,
        WifiClassification.suspicious,
      );

      expect(issues, contains('Unusually short network name'));
    });

    test('should flag numeric-only network names', () {
      final issues = analyzer.generateFlaggedIssues(
        '12345',
        'password',
        WifiSecurityType.wpa2,
        WifiClassification.suspicious,
      );

      expect(issues, contains('Network name is only numbers (suspicious)'));
    });
  });

  group('WifiRiskAnalyzer - Classification Specific Issues', () {
    test('should add critical warnings for unsafe networks', () {
      final issues = analyzer.generateFlaggedIssues(
        'DangerousNet',
        '',
        WifiSecurityType.open,
        WifiClassification.unsafe,
      );

      expect(issues, contains('CRITICAL: High risk of data theft'));
      expect(issues, contains('CRITICAL: Avoid connecting sensitive devices'));
      expect(issues, contains('CRITICAL: All traffic may be monitored'));
      expect(issues, contains('Immediate security threat detected'));
    });

    test('should add warnings for suspicious networks', () {
      final issues = analyzer.generateFlaggedIssues(
        'SuspiciousNet',
        'weak',
        WifiSecurityType.wpa,
        WifiClassification.suspicious,
      );

      expect(issues, contains('WARNING: Security vulnerabilities present'));
      expect(issues, contains('CAUTION: Potential security concerns'));
      expect(issues, contains('Monitor for unusual network behavior'));
      expect(issues, contains('Consider using VPN if connecting'));
    });

    test('should suggest WPA3 upgrade for safe WPA2 networks', () {
      final issues = analyzer.generateFlaggedIssues(
        'SafeNetwork',
        'Str0ng!P@ssw0rd',
        WifiSecurityType.wpa2,
        WifiClassification.safe,
      );

      expect(issues, contains('Consider upgrading to WPA3 for enhanced security'));
    });

    test('should not suggest WPA3 upgrade if already using WPA3', () {
      final issues = analyzer.generateFlaggedIssues(
        'ModernNetwork',
        'Str0ng!P@ssw0rd',
        WifiSecurityType.wpa3,
        WifiClassification.safe,
      );

      expect(issues, isNot(contains('Consider upgrading to WPA3 for enhanced security')));
    });
  });

  group('WifiRiskAnalyzer - Integration Tests', () {
    test('should generate comprehensive issues for completely unsafe network', () {
      final issues = analyzer.generateFlaggedIssues(
        'FreeWiFi',
        '',
        WifiSecurityType.open,
        WifiClassification.unsafe,
      );

      // Should have issues from all categories
      expect(issues.length, greaterThan(5));
      expect(issues.any((i) => i.contains('open without encryption')), isTrue);
      expect(issues.any((i) => i.contains('No password protection')), isTrue);
      expect(issues.any((i) => i.contains('honeypot')), isTrue);
      expect(issues.any((i) => i.contains('CRITICAL')), isTrue);
    });

    test('should generate minimal issues for secure WPA3 network', () {
      final issues = analyzer.generateFlaggedIssues(
        'MySecureHomeNetwork',
        'Str0ng!C0mpl3x@P@ssw0rd123',
        WifiSecurityType.wpa3,
        WifiClassification.safe,
      );

      // Should have very few or no critical issues
      expect(issues.any((i) => i.contains('CRITICAL')), isFalse);
      expect(issues.any((i) => i.contains('WARNING')), isFalse);
    });
  });
}
