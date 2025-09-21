import '../models/models.dart';

class QrUrlAnalysisService {
  Future<QRUrlResponseModel> getQrUrlAnalysis(String url) async {
    await Future.delayed(const Duration(seconds: 2));

    // Mock response with realistic data
    return QRUrlResponseModel(
      id: "358b3774-67cd-42f2-8057-86c387be2ba7",
      url: "https://bit.ly/3I2E6vg", // URL del QR code
      destinationUrl: "http://testsafebrowsing.appspot.com/apiv4/ANY_PLATFORM/MALWARE/URL/", // URL de destino
      scanType: "qr",
      result: Results.unsafe,
      riskLevel: RiskLevel.high,
      classification: UrlClassification.malware,
      confidenceScore: 1.0,
      urlAnalysisScore: 1.0,
      flaggedIssues: [
        "⚠️ Google Web Risk detected: MALWARE",
        "🔗 URL shortener detected",
        "🚨 Redirects to suspicious domain"
      ],
      timestamp: DateTime.now().toIso8601String(),
      processingTime: 2260,
      cached: true,
      expireTime: DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
    );
  }
}
