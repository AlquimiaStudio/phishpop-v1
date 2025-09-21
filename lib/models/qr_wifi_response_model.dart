import 'models.dart';

enum WifiSecurityType { open, wep, wpa, wpa2, wpa3, unknown }

enum WifiRiskLevel { low, medium, high, critical }

enum WifiClassification { safe, unsafe, suspicious }

class QrWifiResponse {
  final String id;
  final String ssid;
  final String password;
  final WifiSecurityType securityType;
  final String scanType;
  final Results result;
  final WifiRiskLevel riskLevel;
  final WifiClassification classification;
  final double confidenceScore;
  final double securityScore;
  final int? signalStrength;
  final List<String> flaggedIssues;
  final String timestamp;
  final int processingTime;
  final bool cached;
  final String? expireTime;

  QrWifiResponse({
    required this.id,
    required this.ssid,
    required this.password,
    required this.securityType,
    required this.scanType,
    required this.result,
    required this.riskLevel,
    required this.classification,
    required this.confidenceScore,
    required this.securityScore,
    this.signalStrength,
    required this.flaggedIssues,
    required this.timestamp,
    required this.processingTime,
    required this.cached,
    this.expireTime,
  });

  factory QrWifiResponse.fromJson(Map<String, dynamic> json) {
    return QrWifiResponse(
      id: json['id'],
      ssid: json['ssid'],
      password: json['password'],
      securityType: _parseSecurityType(json['security_type']),
      scanType: json['scan_type'],
      result: _parseResult(json['result']),
      riskLevel: _parseRiskLevel(json['risk_level']),
      classification: _parseClassification(json['classification']),
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      securityScore: (json['security_score'] as num).toDouble(),
      signalStrength: json['signal_strength'],
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
      'ssid': ssid,
      'password': password,
      'security_type': securityType.name,
      'scan_type': scanType,
      'result': result.name,
      'risk_level': riskLevel.name,
      'classification': classification.name,
      'confidence_score': confidenceScore,
      'security_score': securityScore,
      'signal_strength': signalStrength,
      'flagged_issues': flaggedIssues,
      'timestamp': timestamp,
      'processing_time': processingTime,
      'cached': cached,
      'expireTime': expireTime,
    };
  }

  static WifiSecurityType _parseSecurityType(String value) {
    switch (value.toLowerCase()) {
      case 'open':
        return WifiSecurityType.open;
      case 'wep':
        return WifiSecurityType.wep;
      case 'wpa':
        return WifiSecurityType.wpa;
      case 'wpa2':
        return WifiSecurityType.wpa2;
      case 'wpa3':
        return WifiSecurityType.wpa3;
      default:
        return WifiSecurityType.unknown;
    }
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

  static WifiRiskLevel _parseRiskLevel(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return WifiRiskLevel.low;
      case 'medium':
        return WifiRiskLevel.medium;
      case 'high':
        return WifiRiskLevel.high;
      case 'critical':
        return WifiRiskLevel.critical;
      default:
        return WifiRiskLevel.low;
    }
  }

  static WifiClassification _parseClassification(String value) {
    switch (value.toLowerCase()) {
      case 'safe':
        return WifiClassification.safe;
      case 'unsafe':
        return WifiClassification.unsafe;
      case 'suspicious':
        return WifiClassification.suspicious;
      default:
        return WifiClassification.safe;
    }
  }
}
