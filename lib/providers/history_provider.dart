import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/services.dart';

class HistoryProvider extends ChangeNotifier {
  final ScanDatabaseService databaseService = ScanDatabaseService();
  final PersistentStatsService persistentStatsService =
      PersistentStatsService();

  List<ScanHistoryModel> scanHistory = [];
  bool isLoading = false;
  bool isRefreshing = false;
  String? error;
  bool hasInitialized = false;

  bool get isEmpty => scanHistory.isEmpty && hasInitialized;

  Future<void> initialize() async {
    if (hasInitialized) return;

    setLoading(true);
    try {
      await loadHistoryFromDatabase();
      hasInitialized = true;
      error = null;
    } catch (e) {
      error = 'Failed to load scan history: ${e.toString()}';
      debugPrint('HistoryProvider initialization error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadHistory() async {
    setLoading(true);
    try {
      await loadHistoryFromDatabase();
      error = null;
    } catch (e) {
      error = 'Failed to load scan history: ${e.toString()}';
      debugPrint('HistoryProvider loadHistory error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshHistory() async {
    setRefreshing(true);
    try {
      await loadHistoryFromDatabase();
      error = null;
    } catch (e) {
      error = 'Failed to refresh scan history: ${e.toString()}';
      debugPrint('HistoryProvider refreshHistory error: $e');
    } finally {
      setRefreshing(false);
    }
  }

  Future<void> addScan(ScanHistoryModel scan) async {
    try {
      await databaseService.saveScan(scan);

      await persistentStatsService.recordScan(
        scanType: scan.scanType,
        status: scan.status,
        confidence: scan.score,
        flaggedIssues: scan.flaggedIssues,
        scanDate: scan.timestamp,
      );

      scanHistory.insert(0, scan);

      if (scanHistory.length > 10) {
        scanHistory = scanHistory.take(10).toList();
      }

      error = null;
      notifyListeners();
    } catch (e) {
      error = 'Failed to save scan: ${e.toString()}';
      debugPrint('HistoryProvider addScan error: $e');
      notifyListeners();
    }
  }

  Future<void> deleteScan(String scanId) async {
    try {
      await databaseService.deleteScan(scanId);

      scanHistory.removeWhere((scan) => scan.id == scanId);

      error = null;
      notifyListeners();
    } catch (e) {
      error = 'Failed to delete scan: ${e.toString()}';
      debugPrint('HistoryProvider deleteScan error: $e');
      notifyListeners();
    }
  }

  Future<void> clearAllHistory() async {
    try {
      await databaseService.clearAllScans();

      scanHistory.clear();

      error = null;
      notifyListeners();
    } catch (e) {
      error = 'Failed to clear history: ${e.toString()}';
      debugPrint('HistoryProvider clearAllHistory error: $e');
      notifyListeners();
    }
  }

  Future<ScanHistoryModel?> getScanById(String scanId) async {
    try {
      final cachedScan = scanHistory.firstWhere(
        (scan) => scan.id == scanId,
        orElse: () => throw StateError('Not found in cache'),
      );
      return cachedScan;
    } catch (e) {
      try {
        return await databaseService.getScanById(scanId);
      } catch (dbError) {
        debugPrint('HistoryProvider getScanById error: $dbError');
        return null;
      }
    }
  }

  Future<int> getScanCount() async {
    try {
      return await databaseService.getScanCount();
    } catch (e) {
      debugPrint('HistoryProvider getScanCount error: $e');
      return 0;
    }
  }

  List<ScanHistoryModel> getScansbyType(String scanType) {
    return scanHistory.where((scan) => scan.scanType == scanType).toList();
  }

  List<ScanHistoryModel> getScansByStatus(String status) {
    return scanHistory.where((scan) => scan.status == status).toList();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<void> loadHistoryFromDatabase() async {
    final scans = await databaseService.getRecentScans(limit: 10);
    scanHistory = scans;
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      isLoading = loading;
      notifyListeners();
    }
  }

  void setRefreshing(bool refreshing) {
    if (isRefreshing != refreshing) {
      isRefreshing = refreshing;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    databaseService.close();
    super.dispose();
  }
}
