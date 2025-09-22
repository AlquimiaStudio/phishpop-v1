import 'dart:io';
import 'dart:math' as math;
import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'wifi_risk_analyzer.dart';

class QrWifiAnalysisService {
  final IRiskAnalyzer _riskAnalyzer;

  QrWifiAnalysisService({
    IRiskAnalyzer? riskAnalyzer,
  }) : _riskAnalyzer = riskAnalyzer ?? WifiRiskAnalyzer();

  QrWifiResponse? getQrWifiAnalysis(String wifiContent, HistoryProvider historyProvider) {
    if (!isValidWifiQR(wifiContent)) {
      return null;
    }

    final result = analyzeWifiNetwork(wifiContent);
    
    final historyEntry = createWifiHistoryEntry(result);
    historyProvider.addScan(historyEntry);
    
    return result;
  }

  QrWifiResponse analyzeWifiNetwork(String wifiContent) {
    final wifiData = parseWifiQR(wifiContent);
    final ssid = wifiData['S'] ?? 'Unknown_Network';
    final password = wifiData['P'] ?? '';
    final securityTypeStr = wifiData['T'] ?? 'WPA2';

    final securityType = mapSecurityType(securityTypeStr);
    final classification = classifyNetwork(ssid, password, securityType);
    final riskLevel = determineRiskLevel(ssid, password, securityType);
    final isSecure = analyzeNetworkSecurity(ssid, password, securityType);

    final riskPercentage = _riskAnalyzer.calculateRiskPercentage(
      classification,
    );
    final confidenceScore = _riskAnalyzer.generateConfidenceScore();
    final flaggedIssues = _riskAnalyzer.generateFlaggedIssues(
      ssid,
      password,
      securityType,
      classification,
    );

    return QrWifiResponse(
      id: 'wifi_${DateTime.now().millisecondsSinceEpoch}',
      ssid: ssid,
      password: password,
      securityType: securityType,
      scanType: 'QR WiFi Analysis',
      result: isSecure ? Results.safe : Results.unsafe,
      riskLevel: riskLevel,
      classification: classification,
      confidenceScore: confidenceScore,
      securityScore: riskPercentage / 100,
      signalStrength: -30 - (math.Random().nextInt(40)),
      flaggedIssues: flaggedIssues,
      timestamp: DateTime.now().toIso8601String(),
      processingTime: 10 + math.Random().nextInt(20),
      cached: false,
    );
  }

  Future<bool> connectToWifi(QrWifiResponse wifiData) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (Platform.isAndroid) {
      return wifiData.result == Results.safe;
    } else if (Platform.isIOS) {
      throw Exception(
        'iOS requires manual WiFi connection. Please go to Settings > WiFi and connect to "${wifiData.ssid}" manually.',
      );
    }
    return false;
  }
}
