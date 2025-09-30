import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'wifi_risk_analyzer.dart';

class QrWifiAnalysisService {
  final IRiskAnalyzer _riskAnalyzer;

  QrWifiAnalysisService({IRiskAnalyzer? riskAnalyzer})
    : _riskAnalyzer = riskAnalyzer ?? WifiRiskAnalyzer();

  QrWifiResponse? getQrWifiAnalysis(
    String wifiContent,
    HistoryProvider historyProvider,
  ) {
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

  void showWifiConnectionDialog(BuildContext context, QrWifiResponse wifiData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.wifi, color: Colors.blue, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'WiFi Connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To connect to this network, copy the information below and go to your WiFi settings:',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 20),
            _buildInfoRow('Network Name', wifiData.ssid, Icons.wifi),
            SizedBox(height: 12),
            _buildInfoRow('Password', wifiData.password, Icons.lock),
            SizedBox(height: 12),
            _buildInfoRow(
              'Security',
              wifiData.securityType.name.toUpperCase(),
              Icons.security,
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Go to Settings > WiFi to connect manually',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                SelectableText(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.content_copy, color: Colors.grey[400], size: 18),
        ],
      ),
    );
  }
}
