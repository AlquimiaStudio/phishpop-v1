class PersistentStatsModel {
  final int id;
  final int totalScans;
  final int safeScans;
  final int warningScans;
  final int threatScans;
  final int urlScans;
  final int textScans;
  final int qrScans;
  final int wifiScans;
  final double totalConfidence;
  final String? lastScanDate;
  final String? lastScanType;
  final String createdAt;
  final String updatedAt;

  const PersistentStatsModel({
    required this.id,
    required this.totalScans,
    required this.safeScans,
    required this.warningScans,
    required this.threatScans,
    required this.urlScans,
    required this.textScans,
    required this.qrScans,
    required this.wifiScans,
    required this.totalConfidence,
    this.lastScanDate,
    this.lastScanType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PersistentStatsModel.fromJson(Map<String, dynamic> json) {
    return PersistentStatsModel(
      id: json['id'] as int,
      totalScans: json['total_scans'] as int,
      safeScans: json['safe_scans'] as int,
      warningScans: json['warning_scans'] as int,
      threatScans: json['threat_scans'] as int,
      urlScans: json['url_scans'] as int,
      textScans: json['text_scans'] as int,
      qrScans: json['qr_scans'] as int,
      wifiScans: json['wifi_scans'] as int,
      totalConfidence: json['total_confidence'] as double,
      lastScanDate: json['last_scan_date'] as String?,
      lastScanType: json['last_scan_type'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_scans': totalScans,
      'safe_scans': safeScans,
      'warning_scans': warningScans,
      'threat_scans': threatScans,
      'url_scans': urlScans,
      'text_scans': textScans,
      'qr_scans': qrScans,
      'wifi_scans': wifiScans,
      'total_confidence': totalConfidence,
      'last_scan_date': lastScanDate,
      'last_scan_type': lastScanType,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  PersistentStatsModel copyWith({
    int? id,
    int? totalScans,
    int? safeScans,
    int? warningScans,
    int? threatScans,
    int? urlScans,
    int? textScans,
    int? qrScans,
    int? wifiScans,
    double? totalConfidence,
    String? lastScanDate,
    String? lastScanType,
    String? createdAt,
    String? updatedAt,
  }) {
    return PersistentStatsModel(
      id: id ?? this.id,
      totalScans: totalScans ?? this.totalScans,
      safeScans: safeScans ?? this.safeScans,
      warningScans: warningScans ?? this.warningScans,
      threatScans: threatScans ?? this.threatScans,
      urlScans: urlScans ?? this.urlScans,
      textScans: textScans ?? this.textScans,
      qrScans: qrScans ?? this.qrScans,
      wifiScans: wifiScans ?? this.wifiScans,
      totalConfidence: totalConfidence ?? this.totalConfidence,
      lastScanDate: lastScanDate ?? this.lastScanDate,
      lastScanType: lastScanType ?? this.lastScanType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get averageConfidence => totalScans > 0 ? totalConfidence / totalScans : 0.0;

  Map<String, int> get classificationDistribution => {
    'Safe': safeScans,
    'Suspicious': warningScans,
    'Unsafe': threatScans,
  };

  Map<String, int> get scanTypeDistribution => {
    'URL': urlScans,
    'Text': textScans,
    'QR Code': qrScans,
    'WiFi': wifiScans,
  };

  int get threatsCount => warningScans + threatScans;
  double get threatsPercentage => totalScans > 0 ? (threatsCount / totalScans) * 100 : 0.0;
}

class ThreatCounterModel {
  final String threatName;
  final int count;

  const ThreatCounterModel({
    required this.threatName,
    required this.count,
  });

  factory ThreatCounterModel.fromJson(Map<String, dynamic> json) {
    return ThreatCounterModel(
      threatName: json['threat_name'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threat_name': threatName,
      'count': count,
    };
  }
}