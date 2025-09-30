import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';
import 'http_client.dart';

class TextAnalysisService {
  Future<ITextResponse> getTextAnalysis(String text, HistoryProvider historyProvider) async {
    final response = await HttpClient.postWithRetry(
      "/api/v1/text-analysis",
      {'text': text},
    );

    final textResponse = ITextResponse.fromJson(response.data);
    
    final historyEntry = createTextHistoryEntry(textResponse);
    historyProvider.addScan(historyEntry);
    
    return textResponse;
  }
}
