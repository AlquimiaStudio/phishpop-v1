class IUrlResponse {
  final String id;
  final String url;
  final String scanType;
  final String result;
  final String riskLevel;
  final String classification;
  final double confidenceScore;
  final List<String> flaggedIssues;
  final String timestamp;
  final int processingTime;
  final bool cached;
  final String? expireTime;

  const IUrlResponse({
    required this.id,
    required this.url,
    required this.scanType,
    required this.result,
    required this.riskLevel,
    required this.classification,
    required this.confidenceScore,
    required this.flaggedIssues,
    required this.timestamp,
    required this.processingTime,
    required this.cached,
    this.expireTime,
  });

  factory IUrlResponse.fromJson(Map<String, dynamic> json) {
    return IUrlResponse(
      id: json['id'] as String,
      url: json['url'] as String,
      scanType: json['scan_type'] as String,
      result: json['result'] as String,
      riskLevel: json['risk_level'] as String,
      classification: json['classification'] as String,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      flaggedIssues: List<String>.from(json['flagged_issues'] as List),
      timestamp: json['timestamp'] as String,
      processingTime: json['processing_time'] as int,
      cached: json['cached'] as bool,
      expireTime: json['expire_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'scan_type': scanType,
      'result': result,
      'risk_level': riskLevel,
      'classification': classification,
      'confidence_score': confidenceScore,
      'flagged_issues': flaggedIssues,
      'timestamp': timestamp,
      'processing_time': processingTime,
      'cached': cached,
      'expire_time': expireTime,
    };
  }
}