class ITextResponse {
  final String id;
  final String scanType;
  final double confidenceScore;
  final String riskLevel;
  final String classification;
  final String result;
  final List<String> flaggedIssues;
  final String timestamp;
  final String text;
  final double textAnalysisScore;
  final double? normalizedScore;
  final int processingTime;
  final bool cached;

  const ITextResponse({
    required this.id,
    required this.scanType,
    required this.confidenceScore,
    required this.riskLevel,
    required this.classification,
    required this.result,
    required this.flaggedIssues,
    required this.timestamp,
    required this.text,
    required this.textAnalysisScore,
    this.normalizedScore,
    required this.processingTime,
    required this.cached,
  });

  factory ITextResponse.fromJson(Map<String, dynamic> json) {
    return ITextResponse(
      id: json['id'] as String,
      scanType: json['scan_type'] as String,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
      classification: json['classification'] as String,
      result: json['result'] as String,
      flaggedIssues: List<String>.from(json['flagged_issues'] as List),
      timestamp: json['timestamp'] as String,
      text: json['text'] as String,
      textAnalysisScore: (json['text_analysis_score'] as num).toDouble(),
      normalizedScore: json['normalized_score'] != null
          ? (json['normalized_score'] as num).toDouble()
          : null,
      processingTime: json['processing_time'] as int,
      cached: json['cached'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scan_type': scanType,
      'confidence_score': confidenceScore,
      'risk_level': riskLevel,
      'classification': classification,
      'result': result,
      'flagged_issues': flaggedIssues,
      'timestamp': timestamp,
      'text': text,
      'text_analysis_score': textAnalysisScore,
      'normalized_score': normalizedScore,
      'processing_time': processingTime,
      'cached': cached,
    };
  }
}
