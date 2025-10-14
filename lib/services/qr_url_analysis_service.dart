import 'http_client.dart';
import 'analytics_service.dart';
import 'usage_limits_service.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';

class QrUrlAnalysisService {
  final AnalyticsService analytics = AnalyticsService();
  final UsageLimitsService usageLimits = UsageLimitsService();

  Future<QRUrlResponseModel> getQrUrlAnalysis(
    String url,
    HistoryProvider historyProvider,
  ) async {
    await usageLimits.canScan('qr_url');

    final response = await HttpClient.getWithRetry(
      "/api/v1/qr-analysis",
      queryParameters: {'url': url},
    );

    final urlResponse = QRUrlResponseModel.fromJson(response.data);

    await usageLimits.recordScan('qr_url');

    final historyEntry = createQrUrlHistoryEntry(urlResponse);
    historyProvider.addScan(historyEntry);

    await analytics.logQrScan(
      scanType: 'url',
      riskLevel: urlResponse.riskLevel.toString(),
    );

    if (urlResponse.riskLevel.toString() == 'Threat') {
      await analytics.logThreatDetected(
        threatType: urlResponse.classification.toString(),
        scanType: 'qr_url',
        confidenceScore: urlResponse.confidenceScore,
      );
    }

    return urlResponse;
  }
}
