import '../models/models.dart';
import '../services/persistent_stats_database_service.dart';

class PersistentStatsService {
  final PersistentStatsDatabaseService _databaseService =
      PersistentStatsDatabaseService();

  // Singleton pattern
  static final PersistentStatsService _instance =
      PersistentStatsService._internal();
  factory PersistentStatsService() => _instance;
  PersistentStatsService._internal();

  /// Records a new scan in persistent statistics
  Future<void> recordScan({
    required String scanType,
    required String status,
    required double confidence,
    List<String>? flaggedIssues,
    DateTime? scanDate,
  }) async {
    final date = scanDate ?? DateTime.now();

    // Update main stats counters
    await _databaseService.incrementScanStats(
      scanType: scanType,
      status: status,
      confidence: confidence,
      scanDate: date.toIso8601String(),
    );

    // Add flagged issues to threat counters
    if (flaggedIssues != null && flaggedIssues.isNotEmpty) {
      await _databaseService.addThreatIssues(flaggedIssues);
    }
  }

  /// Gets comprehensive statistics combining persistent data with recent history
  Future<Map<String, dynamic>> getComprehensiveStats(
    List<ScanHistoryModel> recentHistory,
  ) async {
    final persistentStats = await _databaseService.getStats();
    final topThreats = await _databaseService.getTopThreats(limit: 3);

    // Get last activity (prioritize recent history, fallback to persistent)
    Map<String, dynamic> lastActivity;
    if (recentHistory.isNotEmpty) {
      final latestScan = recentHistory.reduce((a, b) {
        final aTime = a.timestamp ?? DateTime.parse(a.date);
        final bTime = b.timestamp ?? DateTime.parse(b.date);
        return aTime.isAfter(bTime) ? a : b;
      });

      final lastTime = latestScan.timestamp ?? DateTime.parse(latestScan.date);
      lastActivity = {
        'date': lastTime,
        'timeAgo': _getTimeAgo(lastTime),
        'scanType': latestScan.scanType,
      };
    } else if (persistentStats.lastScanDate != null) {
      final lastTime = DateTime.parse(persistentStats.lastScanDate!);
      lastActivity = {
        'date': lastTime,
        'timeAgo': _getTimeAgo(lastTime),
        'scanType': persistentStats.lastScanType ?? '',
      };
    } else {
      lastActivity = {'date': null, 'timeAgo': 'No activity', 'scanType': ''};
    }

    // Calculate protection level based on persistent data
    final protectionScore = _calculateProtectionScore(persistentStats);

    return {
      'totalScans': persistentStats.totalScans,
      'threatsDetected': {
        'count': persistentStats.threatsCount,
        'percentage': persistentStats.threatsPercentage,
        'total': persistentStats.totalScans,
      },
      'protectionLevel': {
        'level': _getProtectionLevelText(protectionScore),
        'score': protectionScore,
        'classification': _getProtectionClassification(protectionScore),
      },
      'lastActivity': lastActivity,
      'averageConfidence': persistentStats.averageConfidence,
      'classificationDistribution': persistentStats.classificationDistribution,
      'scanTypeDistribution': persistentStats.scanTypeDistribution,
      'topThreats': topThreats,
    };
  }

  /// Gets only persistent statistics (without recent history)
  Future<PersistentStatsModel> getPersistentStats() async {
    return await _databaseService.getStats();
  }

  /// Gets top threats from persistent counters
  Future<List<String>> getTopThreats({int limit = 3}) async {
    return await _databaseService.getTopThreats(limit: limit);
  }

  /// Migrates existing scan history to persistent stats
  Future<void> migrateExistingHistory(
    List<ScanHistoryModel> scanHistory,
  ) async {
    if (scanHistory.isEmpty) return;

    // Check if migration is needed (if total scans is 0)
    final currentStats = await _databaseService.getStats();
    if (currentStats.totalScans > 0) {
      return; // Already migrated
    }

    // Process each scan in the history
    for (final scan in scanHistory) {
      await recordScan(
        scanType: scan.scanType,
        status: scan.status,
        confidence: scan.score,
        flaggedIssues: scan.flaggedIssues,
        scanDate: scan.timestamp ?? DateTime.parse(scan.date),
      );
    }
  }

  /// Resets all persistent statistics
  Future<void> resetAllStats() async {
    await _databaseService.resetStats();
  }

  /// Helper method to calculate protection score
  double _calculateProtectionScore(PersistentStatsModel stats) {
    if (stats.totalScans == 0) return 100.0;

    final safePercentage = (stats.safeScans / stats.totalScans) * 100;
    final warningPenalty = (stats.warningScans / stats.totalScans) * 20;
    final threatPenalty = (stats.threatScans / stats.totalScans) * 40;

    final score = safePercentage - warningPenalty - threatPenalty;
    return score.clamp(0.0, 100.0);
  }

  /// Helper method to get protection level text
  String _getProtectionLevelText(double score) {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Fair';
    if (score >= 40) return 'Poor';
    return 'Critical';
  }

  /// Helper method to get protection classification
  String _getProtectionClassification(double score) {
    if (score >= 80) return 'high';
    if (score >= 60) return 'medium';
    return 'low';
  }

  /// Helper method to format time ago
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).round()} weeks ago';
    }
    if (difference.inDays < 365) {
      return '${(difference.inDays / 30).round()} months ago';
    }
    return '${(difference.inDays / 365).round()} years ago';
  }

  /// Close database connection
  Future<void> close() async {
    await _databaseService.close();
  }
}
