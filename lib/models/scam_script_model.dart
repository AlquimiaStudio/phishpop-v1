class ScamScript {
  final String id;
  final String title;
  final List<String> redFlags;
  final String safeResponse;
  final List<String> nextSteps;
  final Map<String, String> officialNumbers;
  final List<String> reportSteps;
  final Map<String, String> reportingWebsites;

  const ScamScript({
    required this.id,
    required this.title,
    required this.redFlags,
    required this.safeResponse,
    required this.nextSteps,
    required this.officialNumbers,
    required this.reportSteps,
    required this.reportingWebsites,
  });

  factory ScamScript.fromJson(Map<String, dynamic> json) {
    return ScamScript(
      id: json['id'] as String,
      title: json['title'] as String,
      redFlags: List<String>.from(json['redFlags'] as List),
      safeResponse: json['safeResponse'] as String,
      nextSteps: List<String>.from(json['nextSteps'] as List),
      officialNumbers: Map<String, String>.from(json['officialNumbers'] as Map),
      reportSteps: List<String>.from(json['reportSteps'] as List),
      reportingWebsites: Map<String, String>.from(json['reportingWebsites'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'redFlags': redFlags,
      'safeResponse': safeResponse,
      'nextSteps': nextSteps,
      'officialNumbers': officialNumbers,
      'reportSteps': reportSteps,
      'reportingWebsites': reportingWebsites,
    };
  }
}