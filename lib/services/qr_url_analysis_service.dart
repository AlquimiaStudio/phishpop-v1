import 'package:dio/dio.dart';

import '../models/models.dart';
import '../helpers/helpers.dart';
import '../providers/providers.dart';

class QrUrlAnalysisService {
  final _dio = Dio();

  Future<QRUrlResponseModel> getQrUrlAnalysis(String url, HistoryProvider historyProvider) async {
    final response = await _dio.get(
      "https://phish-pop-express-backend.vercel.app/api/v1/qr-analysis",
      queryParameters: {'url': url},
    );

    final urlResponse = QRUrlResponseModel.fromJson(response.data);

    final historyEntry = createQrUrlHistoryEntry(urlResponse);
    historyProvider.addScan(historyEntry);

    return urlResponse;
  }
}
