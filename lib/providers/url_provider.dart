import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';

class UrlProvider extends ChangeNotifier {
  IUrlResponse? urlAnalysisResult;
  bool isLoading = false;
  String? error;

  void clearAnalysisResult() {
    urlAnalysisResult = null;
    error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    if (loading) error = null;
    notifyListeners();
  }

  Future<void> analyzeUrl(String url) async {
    if (url.trim().isEmpty) return;

    setLoading(true);

    try {
      urlAnalysisResult = await UrlAnalysisService().getUrlAnalysis(url);
    } catch (e) {
      error = 'Error analyzing URL: ${e.toString()}';
      urlAnalysisResult = null;
    } finally {
      setLoading(false);
    }
  }
}
