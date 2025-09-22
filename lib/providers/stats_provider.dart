import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class StatsProvider extends ChangeNotifier {
  final StatsService statsService = StatsService();

  bool isLoading = false;
  String? error;

  int totalScans = 0;
  Map<String, dynamic> threatsDetected = {'count': 0, 'percentage': 0.0, 'total': 0};
  Map<String, dynamic> protectionLevel = {'level': 'No Data', 'score': 0.0, 'classification': 'unknown'};
  Map<String, dynamic> lastActivity = {'date': null, 'timeAgo': 'No activity', 'scanType': ''};
  double averageConfidence = 0.0;
  Map<String, int> classificationDistribution = {'Safe': 0, 'Suspicious': 0, 'Unsafe': 0};
  Map<String, int> scanTypeDistribution = {'URL': 0, 'Text': 0, 'QR Code': 0, 'WiFi': 0};
  List<String> topThreats = [];

  Future<void> loadStats(List<ScanHistoryModel> scanHistory) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        statsService.getTotalScans(scanHistory),
        statsService.getThreatsDetected(scanHistory),
        statsService.getAverageProtectionLevel(scanHistory),
        statsService.getLastActivity(scanHistory),
        statsService.getAverageConfidenceScore(scanHistory),
        statsService.getClassificationDistribution(scanHistory),
        statsService.getScanTypeDistribution(scanHistory),
        statsService.getTopThreats(scanHistory),
      ]);

      totalScans = results[0] as int;
      threatsDetected = results[1] as Map<String, dynamic>;
      protectionLevel = results[2] as Map<String, dynamic>;
      lastActivity = results[3] as Map<String, dynamic>;
      averageConfidence = results[4] as double;
      classificationDistribution = results[5] as Map<String, int>;
      scanTypeDistribution = results[6] as Map<String, int>;
      topThreats = results[7] as List<String>;

      notifyListeners();
    } catch (e) {
      error = 'Failed to load statistics: ${e.toString()}';
      debugPrint('StatsProvider loadStats error: $e');
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStats(List<ScanHistoryModel> scanHistory) async {
    await loadStats(scanHistory);
  }

  void clearStats() {
    totalScans = 0;
    threatsDetected = {'count': 0, 'percentage': 0.0, 'total': 0};
    protectionLevel = {'level': 'No Data', 'score': 0.0, 'classification': 'unknown'};
    lastActivity = {'date': null, 'timeAgo': 'No activity', 'scanType': ''};
    averageConfidence = 0.0;
    classificationDistribution = {'Safe': 0, 'Suspicious': 0, 'Unsafe': 0};
    scanTypeDistribution = {'URL': 0, 'Text': 0, 'QR Code': 0, 'WiFi': 0};
    topThreats = [];
    error = null;
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}