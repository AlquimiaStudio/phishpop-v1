import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';
import 'analytics_service.dart';
import 'usage_limits_service.dart';

class UrlAnalysisService {
  final AnalyticsService analytics = AnalyticsService();
  final UsageLimitsService usageLimits = UsageLimitsService();

  Future<IUrlResponse> getUrlAnalysis(
    String url,
    HistoryProvider historyProvider,
  ) async {
    await usageLimits.canScan('link');

    try {
      final response = await HttpClient.getWithRetry(
        "/api/v1/url-analysis",
        queryParameters: {'url': url},
      );

      final urlResponse = IUrlResponse.fromJson(response.data);

      await usageLimits.recordScan('link');

      final historyEntry = createUrlHistoryEntry(urlResponse);

      historyProvider.addScan(historyEntry);

      // Log analytics event
      await analytics.logUrlScan(
        riskLevel: urlResponse.riskLevel,
        classification: urlResponse.classification,
        confidenceScore: urlResponse.confidenceScore,
      );

      // Log threat if detected
      if (urlResponse.riskLevel == 'Threat') {
        await analytics.logThreatDetected(
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
