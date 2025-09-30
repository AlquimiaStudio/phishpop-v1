import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';

class UrlAnalysisService {
  Future<IUrlResponse> getUrlAnalysis(
    String url,
    HistoryProvider historyProvider,
  ) async {
    final response = await HttpClient.getWithRetry(
      "/api/v1/url-analysis",
      queryParameters: {'url': url},
    );

    final urlResponse = IUrlResponse.fromJson(response.data);
    final historyEntry = createUrlHistoryEntry(urlResponse);

    historyProvider.addScan(historyEntry);

    return urlResponse;
  }
}
