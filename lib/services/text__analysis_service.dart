import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';
import 'analytics_service.dart';
import 'usage_limits_service.dart';

class TextAnalysisService {
  final AnalyticsService analytics = AnalyticsService();
  final UsageLimitsService usageLimits = UsageLimitsService();

  Future<ITextResponse> getTextAnalysis(
    String text,
    HistoryProvider historyProvider,
  ) async {
    await usageLimits.canScan('text');

    try {
      final response = await HttpClient.postWithRetry("/api/v1/text-analysis", {
        'text': text,
      });

      final textResponse = ITextResponse.fromJson(response.data);

      await usageLimits.recordScan('text');

      final historyEntry = createTextHistoryEntry(textResponse);
      historyProvider.addScan(historyEntry);

      // Log analytics event
      await analytics.logTextScan(
        riskLevel: textResponse.riskLevel,
        classification: textResponse.classification,
        confidenceScore: textResponse.confidenceScore,
      );

      // Log threat if detected
      if (textResponse.riskLevel == 'Threat') {
        await analytics.logThreatDetected(
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
