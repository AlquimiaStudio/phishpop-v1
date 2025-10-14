enum Results { safe, unsafe, unknown }

enum RiskLevel { low, medium, high, critical }

enum UrlClassification { safe, malware, phishing, suspicious, blocked }

class QRUrlResponseModel {
  final String id;
  final String url;
  final String destinationUrl;
  final String scanType;
  final Results result;
  final RiskLevel riskLevel;
  final UrlClassification classification;
  final double confidenceScore;
  final double urlAnalysisScore;
  final List<String> flaggedIssues;
  final String timestamp;
  final int processingTime;
  final bool cached;
  final String? expireTime;

  QRUrlResponseModel({
    required this.id,
    required this.url,
    required this.destinationUrl,
    required this.scanType,
    required this.result,
    required this.riskLevel,
    required this.classification,
    required this.confidenceScore,
    required this.urlAnalysisScore,
    required this.flaggedIssues,
    required this.timestamp,
    required this.processingTime,
    required this.cached,
    this.expireTime,
  });

  factory QRUrlResponseModel.fromJson(Map<String, dynamic> json) {
    return QRUrlResponseModel(
      id: json['id'],
      url: json['url'],
      destinationUrl: json['destination_url'],
      scanType: json['scan_type'],
      result: _parseResult(json['result']),
      riskLevel: _parseRiskLevel(json['risk_level']),
      classification: _parseClassification(json['classification']),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      urlAnalysisScore: (json['url_analysis_score'] as num).toDouble(),
      flaggedIssues: List<String>.from(json['flagged_issues']),
      timestamp: json['timestamp'],
      processingTime: json['processing_time'],
      cached: json['cached'],
      expireTime: json['expireTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'destination_url': destinationUrl,
      'scan_type': scanType,
      'result': result.name,
      'risk_level': riskLevel.name,
      'classification': classification.name,
      'confidence_score': confidenceScore,
      'url_analysis_score': urlAnalysisScore,
      'flagged_issues': flaggedIssues,
      'timestamp': timestamp,
      'processing_time': processingTime,
      'cached': cached,
      'expireTime': expireTime,
    };
  }

  static Results _parseResult(String value) {
    switch (value.toLowerCase()) {
      case 'safe':
        return Results.safe;
      case 'unsafe':
        return Results.unsafe;
      case 'unknown':
        return Results.unknown;
      default:
        return Results.unknown;
    }
  }

  static RiskLevel _parseRiskLevel(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return RiskLevel.low;
      case 'medium':
        return RiskLevel.medium;
      case 'high':
        return RiskLevel.high;
      case 'critical':
        return RiskLevel.critical;
      default:
        return RiskLevel.low;
    }
  }

  static UrlClassification _parseClassification(String value) {
    switch (value.toLowerCase()) {
      case 'safe':
        return UrlClassification.safe;
      case 'malware':
        return UrlClassification.malware;
      case 'phishing':
        return UrlClassification.phishing;
      case 'suspicious':
        return UrlClassification.suspicious;
      case 'blocked':
        return UrlClassification.blocked;
      default:
        return UrlClassification.safe;
    }
  }
}
