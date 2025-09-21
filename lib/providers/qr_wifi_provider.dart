import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';

class QrWifiProvider extends ChangeNotifier {
  QrWifiResponse? qrWifiAnalysisResult;
  bool isLoading = false;
  String? error;

  void clearAnalysisResult() {
    qrWifiAnalysisResult = null;
    error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    if (loading) error = null;
    notifyListeners();
  }

  Future<void> analyzeQrWifi(String wifiContent) async {
    if (wifiContent.trim().isEmpty) return;

    try {
      qrWifiAnalysisResult = QrWifiAnalysisService().getQrWifiAnalysis(
        wifiContent,
      );
      error = null;
      notifyListeners();
    } catch (e) {
      error = 'Error analyzing WiFi QR: ${e.toString()}';
      qrWifiAnalysisResult = null;
      notifyListeners();
    }
  }

  Future<bool> connectToWifi() async {
    if (qrWifiAnalysisResult == null) return false;

    try {
      return await QrWifiAnalysisService().connectToWifi(qrWifiAnalysisResult!);
    } catch (e) {
      error = 'Error connecting to WiFi: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
