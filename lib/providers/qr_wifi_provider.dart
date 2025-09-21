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

    setLoading(true);

    try {
      qrWifiAnalysisResult = await QrWifiAnalysisService().getQrWifiAnalysis(
        wifiContent,
      );
    } catch (e) {
      error = 'Error analyzing WiFi QR: ${e.toString()}';
      qrWifiAnalysisResult = null;
    } finally {
      setLoading(false);
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
