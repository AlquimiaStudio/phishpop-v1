import 'package:dio/dio.dart';
import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';

class TextAnalysisService {
  final _dio = Dio();

  Future<ITextResponse> getTextAnalysis(String text, HistoryProvider historyProvider) async {
    final response = await _dio.post(
      "https://phish-pop-express-backend.vercel.app/api/v1/text-analysis",
      data: {'text': text},
    );

    final textResponse = ITextResponse.fromJson(response.data);
    
    final historyEntry = createTextHistoryEntry(textResponse);
    historyProvider.addScan(historyEntry);
    
    return textResponse;
  }
}
