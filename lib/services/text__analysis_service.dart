import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';
import 'analytics_service.dart';

class TextAnalysisService {
  final AnalyticsService _analytics = AnalyticsService();

  Future<ITextResponse> getTextAnalysis(String text, HistoryProvider historyProvider) async {
    try {
      final response = await HttpClient.postWithRetry(
        "/api/v1/text-analysis",
        {'text': text},
      );

      final textResponse = ITextResponse.fromJson(response.data);

      final historyEntry = createTextHistoryEntry(textResponse);
      historyProvider.addScan(historyEntry);

      // Log analytics event
      await _analytics.logTextScan(
        riskLevel: textResponse.riskLevel,
        classification: textResponse.classification,
        confidenceScore: textResponse.confidenceScore,
      );

      // Log threat if detected
      if (textResponse.riskLevel == 'Threat') {
        await _analytics.logThreatDetected(
          threatType: textResponse.classification,
          scanType: 'text',
          confidenceScore: textResponse.confidenceScore,
        );
      }

      return textResponse;
    } catch (error, stackTrace) {
      // Report error to Crashlytics
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Text Analysis failed',
      );
      rethrow;
    }
  }
}
