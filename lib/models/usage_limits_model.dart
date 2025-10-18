class UsageLimits {
  static const Map<String, int> premiumLimits = {
    'text': 360,
    'email': 360,
    'link': 360,
    'qr_url': 300,
    'qr_wifi': -1,
  };

  static const Map<String, int> freeLimits = {
    'total': 10, // Total scans shared across all types
    'qr_wifi': -1, // WiFi QR remains unlimited
  };

  static int getLimit(String scanType, bool isPremium) {
    final limits = isPremium ? premiumLimits : freeLimits;

    if (scanType == 'qr_wifi') {
      return limits[scanType] ?? -1;
    }

    if (!isPremium) {
      return limits['total'] ?? 0;
    }

    return limits[scanType] ?? 0;
  }

  static bool isUnlimited(String scanType) {
    return premiumLimits[scanType] == -1;
  }

  static int getDailyLimit(String scanType, bool isPremium) {
    final monthlyLimit = getLimit(scanType, isPremium);
    if (monthlyLimit == -1) return -1;
    return (monthlyLimit / 30).ceil();
  }

  static bool countsTowardTotal(String scanType) {
    return scanType != 'qr_wifi';
  }
}

class UsageStats {
  final String scanType;
  final int currentCount;
  final int limit;
  final DateTime? resetDate;
  final DateTime? lastScanDate;

  UsageStats({
    required this.scanType,
    required this.currentCount,
    required this.limit,
    this.resetDate,
    this.lastScanDate,
  });

  int get remaining => limit == -1 ? -1 : limit - currentCount;

  double get percentage =>
      limit == -1 ? 0 : (currentCount / limit * 100).clamp(0, 100);

  bool get isExceeded => limit != -1 && currentCount >= limit;

  bool get isNearLimit => limit != -1 && percentage >= 80;

  bool get isUnlimited => limit == -1;

  Map<String, dynamic> toJson() {
    return {
      'scan_type': scanType,
      'current_count': currentCount,
      'limit': limit,
      'reset_date': resetDate?.toIso8601String(),
      'last_scan_date': lastScanDate?.toIso8601String(),
      'remaining': remaining,
      'percentage': percentage,
      'is_exceeded': isExceeded,
      'is_near_limit': isNearLimit,
      'is_unlimited': isUnlimited,
    };
  }

  factory UsageStats.fromJson(Map<String, dynamic> json) {
    return UsageStats(
      scanType: json['scan_type'] as String,
      currentCount: json['current_count'] as int,
      limit: json['limit'] as int,
      resetDate: json['reset_date'] != null
          ? DateTime.parse(json['reset_date'] as String)
          : null,
      lastScanDate: json['last_scan_date'] != null
          ? DateTime.parse(json['last_scan_date'] as String)
          : null,
    );
  }
}
