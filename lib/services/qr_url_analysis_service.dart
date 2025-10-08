import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';
import 'analytics_service.dart';

class QrUrlAnalysisService {
  final AnalyticsService _analytics = AnalyticsService();

  Future<QRUrlResponseModel> getQrUrlAnalysis(
    String url,
    HistoryProvider historyProvider,
  ) async {
    final response = await HttpClient.getWithRetry(
      "/api/v1/qr-analysis",
      queryParameters: {'url': url},
    );

    final urlResponse = QRUrlResponseModel.fromJson(response.data);

    final historyEntry = createQrUrlHistoryEntry(urlResponse);
    historyProvider.addScan(historyEntry);

    // Log analytics event
    await _analytics.logQrScan(
      scanType: 'url',
      riskLevel: urlResponse.riskLevel.toString(),
    );

    // Log threat if detected
    if (urlResponse.riskLevel.toString() == 'Threat') {
      await _analytics.logThreatDetected(
        threatType: urlResponse.classification.toString(),
        scanType: 'qr_url',
        confidenceScore: urlResponse.confidenceScore,
      );
    }

    return urlResponse;
  }
}
