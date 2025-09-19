import 'package:dio/dio.dart';

import '../models/models.dart';

class TextAnalysisService {
  final _dio = Dio();

  Future<ITextResponse> getTextAnalysis(String text) async {
    final response = await _dio.post(
      "https://phish-pop-express-backend.vercel.app/api/v1/text-analysis",
      data: {'text': text},
    );

    final textResponse = ITextResponse.fromJson(response.data);
    return textResponse;
  }
}
