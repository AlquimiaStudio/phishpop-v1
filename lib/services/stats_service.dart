import '../models/models.dart';

abstract class IStatsService {
  Future<int> getTotalScans(List<ScanHistoryModel> scanHistory);
  Future<Map<String, dynamic>> getThreatsDetected(List<ScanHistoryModel> scanHistory);
  Future<Map<String, dynamic>> getAverageProtectionLevel(List<ScanHistoryModel> scanHistory);
  Future<Map<String, dynamic>> getLastActivity(List<ScanHistoryModel> scanHistory);
  Future<double> getAverageConfidenceScore(List<ScanHistoryModel> scanHistory);
  Future<Map<String, int>> getClassificationDistribution(List<ScanHistoryModel> scanHistory);
  Future<Map<String, int>> getScanTypeDistribution(List<ScanHistoryModel> scanHistory);
  Future<List<String>> getTopThreats(List<ScanHistoryModel> scanHistory);
}

class StatsService implements IStatsService {
  @override
  Future<int> getTotalScans(List<ScanHistoryModel> scanHistory) async {
    return scanHistory.length;
  }

  @override
  Future<Map<String, dynamic>> getThreatsDetected(List<ScanHistoryModel> scanHistory) async {
    if (scanHistory.isEmpty) {
      return {
        'count': 0,
        'percentage': 0.0,
        'total': 0,
      };
    }

    final threatsCount = scanHistory.where((scan) {
      return _isThreat(scan.status);
    }).length;

    final percentage = (threatsCount / scanHistory.length) * 100;

    return {
      'count': threatsCount,
      'percentage': percentage,
      'total': scanHistory.length,
    };
  }

  @override
  Future<Map<String, dynamic>> getAverageProtectionLevel(List<ScanHistoryModel> scanHistory) async {
    if (scanHistory.isEmpty) {
      return {
        'level': 'No Data',
        'score': 0.0,
        'classification': 'unknown',
      };
    }

    final totalScore = scanHistory.fold<double>(0.0, (sum, scan) => sum + scan.score);
    final averageScore = totalScore / scanHistory.length;

    return {
      'level': _getProtectionLevelText(averageScore),
      'score': averageScore,
      'classification': _getProtectionClassification(averageScore),
    };
  }

  @override
  Future<Map<String, dynamic>> getLastActivity(List<ScanHistoryModel> scanHistory) async {
    if (scanHistory.isEmpty) {
      return {
        'date': null,
        'timeAgo': 'No activity',
        'scanType': '',
      };
    }

    final latestScan = scanHistory.reduce((a, b) {
      final aTime = a.timestamp ?? DateTime.parse(a.date);
      final bTime = b.timestamp ?? DateTime.parse(b.date);
      return aTime.isAfter(bTime) ? a : b;
    });

    final lastActivity = latestScan.timestamp ?? DateTime.parse(latestScan.date);
    final timeAgo = _getTimeAgo(lastActivity);

    return {
      'date': lastActivity,
      'timeAgo': timeAgo,
      'scanType': latestScan.scanType,
    };
  }

  @override
  Future<double> getAverageConfidenceScore(List<ScanHistoryModel> scanHistory) async {
    if (scanHistory.isEmpty) return 0.0;

    final totalScore = scanHistory.fold<double>(0.0, (sum, scan) => sum + scan.score);
    return totalScore / scanHistory.length;
  }

  @override
  Future<Map<String, int>> getClassificationDistribution(List<ScanHistoryModel> scanHistory) async {
    final Map<String, int> distribution = {
      'Safe': 0,
      'Suspicious': 0,
      'Unsafe': 0,
    };

    for (final scan in scanHistory) {
      final status = scan.status.toLowerCase();
      if (status == 'safe') {
        distribution['Safe'] = distribution['Safe']! + 1;
      } else if (status == 'warning') {
        distribution['Suspicious'] = distribution['Suspicious']! + 1;
      } else if (status == 'threat') {
        distribution['Unsafe'] = distribution['Unsafe']! + 1;
      }
    }

    return distribution;
  }

  @override
  Future<Map<String, int>> getScanTypeDistribution(List<ScanHistoryModel> scanHistory) async {
    final Map<String, int> distribution = {
      'URL': 0,
      'Text': 0,
      'QR Code': 0,
      'WiFi': 0,
    };

    for (final scan in scanHistory) {
      final scanType = scan.scanType.toLowerCase();
      if (scanType.contains('url')) {
        distribution['URL'] = distribution['URL']! + 1;
      } else if (scanType.contains('text')) {
        distribution['Text'] = distribution['Text']! + 1;
      } else if (scanType.contains('qr')) {
        distribution['QR Code'] = distribution['QR Code']! + 1;
      } else if (scanType.contains('wifi')) {
        distribution['WiFi'] = distribution['WiFi']! + 1;
      }
    }

    return distribution;
  }

  @override
  Future<List<String>> getTopThreats(List<ScanHistoryModel> scanHistory) async {
    final Map<String, int> threatCounts = {};

    for (final scan in scanHistory) {
      if (scan.flaggedIssues != null && scan.flaggedIssues!.isNotEmpty) {
        for (final issue in scan.flaggedIssues!) {
          threatCounts[issue] = (threatCounts[issue] ?? 0) + 1;
        }
      }
    }

    final sortedThreats = threatCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedThreats.take(3).map((e) => e.key).toList();
  }

  bool _isThreat(String status) {
    final threatStatuses = ['warning', 'threat'];
    return threatStatuses.contains(status.toLowerCase());
  }

  String _getProtectionLevelText(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Poor';
  }

  String _getProtectionClassification(double score) {
    if (score >= 80) return 'excellent';
    if (score >= 60) return 'good';
    if (score >= 40) return 'fair';
    return 'poor';
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}