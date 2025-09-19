class ScanHistoryModel {
  final String scanType;
  final String title;
  final String date;
  final String status;
  final double score;

  const ScanHistoryModel({
    required this.scanType,
    required this.title,
    required this.date,
    required this.status,
    required this.score,
  });

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryModel(
      scanType: json['scanType'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      score: (json['score'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scanType': scanType,
      'title': title,
      'date': date,
      'status': status,
      'score': score,
    };
  }
}
