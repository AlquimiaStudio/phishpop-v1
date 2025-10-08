import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';
import 'analytics_service.dart';

class UrlAnalysisService {
  final AnalyticsService _analytics = AnalyticsService();

  Future<IUrlResponse> getUrlAnalysis(
    String url,
    HistoryProvider historyProvider,
  ) async {
    try {
      final response = await HttpClient.getWithRetry(
        "/api/v1/url-analysis",
        queryParameters: {'url': url},
      );

      final urlResponse = IUrlResponse.fromJson(response.data);
      final historyEntry = createUrlHistoryEntry(urlResponse);

      historyProvider.addScan(historyEntry);

      // Log analytics event
      await _analytics.logUrlScan(
        riskLevel: urlResponse.riskLevel,
        classification: urlResponse.classification,
        confidenceScore: urlResponse.confidenceScore,
      );

      // Log threat if detected
      if (urlResponse.riskLevel == 'Threat') {
        await _analytics.logThreatDetected(
          threatType: urlResponse.classification,
          scanType: 'url',
          confidenceScore: urlResponse.confidenceScore,
        );
      }

      return urlResponse;
    } catch (error, stackTrace) {
      // Report error to Crashlytics
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'URL Analysis failed for: $url',
      );
      rethrow;
    }
  }
}
