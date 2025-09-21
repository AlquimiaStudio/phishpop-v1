import 'package:dio/dio.dart';
import '../models/models.dart';

class QrUrlAnalysisService {
  final _dio = Dio();

  Future<QRUrlResponseModel> getQrUrlAnalysis(String url) async {
    final response = await _dio.get(
      "https://phish-pop-express-backend.vercel.app/api/v1/qr-analysis",
      queryParameters: {'url': url},
    );

    final urlResponse = QRUrlResponseModel.fromJson(response.data);
    return urlResponse;
  }
}
