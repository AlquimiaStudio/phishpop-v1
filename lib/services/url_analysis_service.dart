import 'package:dio/dio.dart';

import '../models/models.dart';

class UrlAnalysisService {
  final _dio = Dio();

  Future<IUrlResponse> getUrlAnalysis(String url) async {
    final response = await _dio.get(
      "https://phish-pop-express-backend.vercel.app/api/v1/url-analysis",
      queryParameters: {'url': url},
    );

    final urlResponse = IUrlResponse.fromJson(response.data);
    return urlResponse;
  }
}
