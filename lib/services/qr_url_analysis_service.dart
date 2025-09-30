import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';

class QrUrlAnalysisService {
  Future<QRUrlResponseModel> getQrUrlAnalysis(String url, HistoryProvider historyProvider) async {
    final response = await HttpClient.getWithRetry(
      "/api/v1/qr-analysis",
      queryParameters: {'url': url},
    );

    final urlResponse = QRUrlResponseModel.fromJson(response.data);

    final historyEntry = createQrUrlHistoryEntry(urlResponse);
    historyProvider.addScan(historyEntry);

    return urlResponse;
  }
}
