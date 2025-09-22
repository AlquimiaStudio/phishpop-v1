import 'package:flutter/material.dart';

import 'providers.dart';
import '../models/models.dart';
import '../services/services.dart';

class QrUrlProvider extends ChangeNotifier {
  QRUrlResponseModel? qrUrlAnalysisResult;
  bool isLoading = false;
  String? error;

  void clearAnalysisResult() {
    qrUrlAnalysisResult = null;
    error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    if (loading) error = null;
    notifyListeners();
  }

  Future<void> analyzeQrUrl(String url, HistoryProvider historyProvider) async {
    if (url.trim().isEmpty) return;

    setLoading(true);

    try {
      qrUrlAnalysisResult = await QrUrlAnalysisService().getQrUrlAnalysis(
        url,
        historyProvider,
      );
    } catch (e) {
      error = 'Error analyzing QR URL: ${e.toString()}';
      qrUrlAnalysisResult = null;
    } finally {
      setLoading(false);
    }
  }
}
