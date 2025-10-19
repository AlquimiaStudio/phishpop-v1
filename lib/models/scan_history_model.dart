class ScanHistoryModel {
  final String id;
  final String scanType;
  final String title;
  final String date;
  final String status;
  final double score;
  final DateTime? timestamp;
  final Map<String, dynamic>? details;
  final List<String>? flaggedIssues;
  final String? riskLevel;

  const ScanHistoryModel({
    required this.id,
    required this.scanType,
    required this.title,
    required this.date,
    required this.status,
    required this.score,
    this.timestamp,
    this.details,
    this.flaggedIssues,
    this.riskLevel,
  });

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryModel(
      id: json['id'] as String? ?? '',
      scanType: json['scanType'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      score: (json['score'] as num).toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      details: json['details'] as Map<String, dynamic>?,
      flaggedIssues: json['flaggedIssues'] != null
          ? List<String>.from(json['flaggedIssues'])
          : null,
      riskLevel: json['riskLevel'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scanType': scanType,
      'title': title,
      'date': date,
      'status': status,
      'score': score,
      'timestamp': timestamp?.toIso8601String(),
      'details': details,
      'flaggedIssues': flaggedIssues,
      'riskLevel': riskLevel,
    };
  }
}
