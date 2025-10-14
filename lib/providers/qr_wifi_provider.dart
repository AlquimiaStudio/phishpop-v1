import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';
import 'history_provider.dart';

class QrWifiProvider extends ChangeNotifier {
  QrWifiResponse? qrWifiAnalysisResult;
  bool isLoading = false;
  bool isRefreshing = false;
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

  Future<void> analyzeQrWifi(
    String wifiContent,
    HistoryProvider historyProvider, {
    bool isRefresh = false,
  }) async {
    if (wifiContent.trim().isEmpty) return;

    if (isRefresh) {
      isRefreshing = true;
    } else {
      setLoading(true);
    }

    try {
      qrWifiAnalysisResult = await QrWifiAnalysisService().getQrWifiAnalysis(
        wifiContent,
        historyProvider,
      );
      error = null;
    } catch (e) {
      error = 'Error analyzing WiFi QR: ${e.toString()}';
      qrWifiAnalysisResult = null;
    } finally {
      if (isRefresh) {
        isRefreshing = false;
      } else {
        setLoading(false);
      }
      notifyListeners();
    }
  }
}
