import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';

class TextProvider extends ChangeNotifier {
  ITextResponse? textAnalysisResult;
  bool isLoading = false;
  String? error;

  void clearAnalysisResult() {
    textAnalysisResult = null;
    error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    if (loading) error = null;
    notifyListeners();
  }

  Future<void> analyzeText(String text) async {
    if (text.trim().isEmpty) return;

    setLoading(true);

    try {
      textAnalysisResult = await TextAnalysisService().getTextAnalysis(text);
    } catch (e) {
      error = 'Error analyzing text: ${e.toString()}';
      textAnalysisResult = null;
    } finally {
      setLoading(false);
    }
  }
}
