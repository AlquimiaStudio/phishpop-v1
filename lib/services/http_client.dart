import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpClient {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 60), // Aumentado para Railway connection
      receiveTimeout: Duration(seconds: 90), // Aumentado para OpenAI processing
      sendTimeout: Duration(seconds: 60), // Aumentado para textos largos
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Dio get instance => _dio;

  static Future<Response> postWithRetry(String path, dynamic data) async {
    for (int i = 0; i < 3; i++) {
      try {
        return await _dio.post(path, data: data);
      } on DioException catch (e) {
        // Retry on timeout or server errors (500, 502, 503, 504)
        final shouldRetry = i < 2 && (
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          (e.response?.statusCode != null &&
           e.response!.statusCode! >= 500 &&
           e.response!.statusCode! < 600)
        );

        if (shouldRetry) {
          // Exponential backoff: 2s, 4s
          await Future.delayed(Duration(seconds: 2 * (i + 1)));
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
