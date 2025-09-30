import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpClient {
  static final String baseUrl =
      dotenv.env['API_BASE_URL'] ??
      'https://phish-pop-express-backend.vercel.app';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 8),
      sendTimeout: Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Dio get instance => _dio;

  static Future<Response> postWithRetry(String path, dynamic data) async {
    for (int i = 0; i < 2; i++) {
      try {
        return await _dio.post(path, data: data);
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout && i < 1) {
          await Future.delayed(Duration(seconds: 2));
          continue;
        }
        rethrow;
      }
    }
    throw Exception('Max retries exceeded');
  }

  static Future<Response> getWithRetry(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    for (int i = 0; i < 2; i++) {
      try {
        return await _dio.get(path, queryParameters: queryParameters);
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout && i < 1) {
          await Future.delayed(Duration(seconds: 2));
          continue;
        }
        rethrow;
      }
    }
    throw Exception('Max retries exceeded');
  }
}
