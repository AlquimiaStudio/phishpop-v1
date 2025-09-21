import 'dart:io';
import 'dart:math' as math;
import '../models/models.dart';
import '../helpers/helpers.dart';

class QrWifiAnalysisService {
  Future<QrWifiResponse?> getQrWifiAnalysis(String wifiContent) async {
    if (!isValidWifiQR(wifiContent)) {
      return null;
    }

    return generateMockResponse(wifiContent);
  }

  Future<bool> connectToWifi(QrWifiResponse wifiData) async {
    await Future.delayed(const Duration(seconds: 1));

    if (Platform.isAndroid) {
      return wifiData.result == Results.safe;
    } else if (Platform.isIOS) {
      throw Exception(
        'iOS requires manual WiFi connection. Please go to Settings > WiFi and connect to "${wifiData.ssid}" manually.',
      );
    }
    return false;
  }

  QrWifiResponse generateMockResponse(String wifiContent) {
    final wifiData = parseWifiQR(wifiContent);
    final ssid = wifiData['S'] ?? 'Unknown_Network';
    final password = wifiData['P'] ?? '';
    final securityTypeStr = wifiData['T'] ?? 'WPA2';

    final securityType = mapSecurityType(securityTypeStr);
    final isSecure = analyzeNetworkSecurity(ssid, password, securityType);

    return QrWifiResponse(
      id: 'wifi_${DateTime.now().millisecondsSinceEpoch}',
      ssid: ssid,
      password: password,
      securityType: securityType,
      scanType: 'QR WiFi Analysis',
      result: isSecure ? Results.safe : Results.unsafe,
      riskLevel: determineRiskLevel(ssid, password, securityType),
      classification: classifyNetwork(ssid, password, securityType),
      confidenceScore: 0.85 + (math.Random().nextDouble() * 0.15),
      securityScore: calculateSecurityScore(password, securityType),
      signalStrength: -30 - (math.Random().nextInt(40)),
      flaggedIssues: identifyIssues(ssid, password, securityType),
      timestamp: DateTime.now().toIso8601String(),
      processingTime: 1200 + math.Random().nextInt(800),
      cached: false,
    );
  }
}
