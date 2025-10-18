import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';
import '../exceptions/exceptions.dart';
import 'services.dart';

class UsageLimitsService {
  static final UsageLimitsService instance = UsageLimitsService.internal();
  factory UsageLimitsService() => instance;
  UsageLimitsService.internal();

  final UsageLimitsDatabaseService db = UsageLimitsDatabaseService();
  final RevenueCatService revenueCat = RevenueCatService();

  String? cachedUserId;
  bool? cachedIsPremium;
  DateTime? lastPremiumCheck;

  Future<String> getUserId() async {
    if (cachedUserId != null) return cachedUserId!;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw UserNotAuthenticatedException();

    cachedUserId = user.uid;
    return cachedUserId!;
  }

  Future<bool> isPremium() async {
    final now = DateTime.now();

    if (cachedIsPremium != null &&
        lastPremiumCheck != null &&
        now.difference(lastPremiumCheck!).inMinutes < 5) {
      return cachedIsPremium!;
    }

    final isPremium = await revenueCat.isUserPremium();
    cachedIsPremium = isPremium;
    lastPremiumCheck = now;

    return isPremium;
  }

  Future<bool> canScan(String scanType) async {
    try {
      final userId = await getUserId();

      await db.checkAndResetIfNeeded(userId);

      if (scanType == 'qr_wifi') {
        return true;
      }

      final premium = await isPremium();
      final limit = UsageLimits.getLimit(scanType, premium);

      if (limit == 0) {
        return false;
      }

      if (limit == -1) {
        return true;
      }

      final typeToCheck = premium ? scanType : 'total';
      final record = await db.getScanCount(userId, typeToCheck);
      final currentCount = record?['count'] as int? ?? 0;

      if (currentCount >= limit) {
        final resetDate = record?['reset_date'] != null
            ? DateTime.parse(record!['reset_date'] as String)
            : null;

        throw LimitReachedException(
          scanType: premium ? scanType : 'total',
          currentCount: currentCount,
          limit: limit,
          resetDate: resetDate,
        );
      }

      return true;
    } on UsageLimitException {
      rethrow;
    } catch (e) {
      log('Error checking scan limits: $e');
      throw UsageLimitDatabaseException(e);
    }
  }

  Future<void> recordScan(String scanType) async {
    try {
      final userId = await getUserId();

      if (scanType == 'qr_wifi') {
        return;
      }

      final premium = await isPremium();
      final typeToRecord = premium ? scanType : 'total';

      await db.incrementScanCount(userId, typeToRecord);

      final stats = await getUsageStats(typeToRecord);
      if (stats != null) {
        if (stats.isExceeded) {
          log('User exceeded limit for $typeToRecord');
        } else if (stats.isNearLimit) {
          log('User approaching limit for $typeToRecord: ${stats.percentage}%');
        }
      }
    } catch (e) {
      log('Error recording scan: $e');
    }
  }

  Future<Map<String, UsageStats>> getAllUsageStats() async {
    try {
      final userId = await getUserId();
      final premium = await isPremium();

      await db.checkAndResetIfNeeded(userId);

      final resetDate = await db.getNextResetDate(userId);
      final stats = <String, UsageStats>{};

      // For free users, only return 'total' stats (shared limit)
      if (!premium) {
        final record = await db.getScanCount(userId, 'total');
        final currentCount = record?['count'] as int? ?? 0;
        final lastScanDate = record?['last_scan_date'] != null
            ? DateTime.parse(record!['last_scan_date'] as String)
            : null;

        stats['total'] = UsageStats(
          scanType: 'total',
          currentCount: currentCount,
          limit: UsageLimits.getLimit('total', false),
          resetDate: resetDate,
          lastScanDate: lastScanDate,
        );

        return stats;
      }

      // For premium users, return stats for all scan types
      final counts = await db.getAllScanCounts(userId);

      for (final scanType in UsageLimits.premiumLimits.keys) {
        final limit = UsageLimits.getLimit(scanType, premium);
        final currentCount = counts[scanType] ?? 0;

        final record = await db.getScanCount(userId, scanType);
        final lastScanDate = record?['last_scan_date'] != null
            ? DateTime.parse(record!['last_scan_date'] as String)
            : null;

        stats[scanType] = UsageStats(
          scanType: scanType,
          currentCount: currentCount,
          limit: limit,
          resetDate: resetDate,
          lastScanDate: lastScanDate,
        );
      }

      return stats;
    } catch (e) {
      log('Error getting usage stats: $e');
      return {};
    }
  }

  Future<UsageStats?> getUsageStats(String scanType) async {
    try {
      final userId = await getUserId();
      final premium = await isPremium();

      await db.checkAndResetIfNeeded(userId);

      final limit = UsageLimits.getLimit(scanType, premium);
      final record = await db.getScanCount(userId, scanType);

      final currentCount = record?['count'] as int? ?? 0;
      final resetDate = record?['reset_date'] != null
          ? DateTime.parse(record!['reset_date'] as String)
          : null;
      final lastScanDate = record?['last_scan_date'] != null
          ? DateTime.parse(record!['last_scan_date'] as String)
          : null;

      return UsageStats(
        scanType: scanType,
        currentCount: currentCount,
        limit: limit,
        resetDate: resetDate,
        lastScanDate: lastScanDate,
      );
    } catch (e) {
      log('Error getting usage stats for $scanType: $e');
      return null;
    }
  }

  Future<void> resetAllCounters() async {
    try {
      final userId = await getUserId();
      await db.resetAllCounters(userId);
      log('All usage counters reset for user $userId');
    } catch (e) {
      log('Error resetting counters: $e');
    }
  }

  Future<DateTime?> getNextResetDate() async {
    try {
      final userId = await getUserId();
      return await db.getNextResetDate(userId);
    } catch (e) {
      log('Error getting next reset date: $e');
      return null;
    }
  }

  Future<int> getTotalUsage() async {
    try {
      final userId = await getUserId();
      final premium = await isPremium();

      if (premium) {
        final counts = await db.getAllScanCounts(userId);
        return counts.values.fold<int>(0, (sum, count) => sum + count);
      }

      final record = await db.getScanCount(userId, 'total');
      return record?['count'] as int? ?? 0;
    } catch (e) {
      log('Error getting total usage: $e');
      return 0;
    }
  }

  Future<int> getRemainingScans() async {
    try {
      final premium = await isPremium();

      if (premium) {
        return -1;
      }

      final limit = UsageLimits.getLimit('total', false);
      final usage = await getTotalUsage();

      return (limit - usage).clamp(0, limit);
    } catch (e) {
      log('Error getting remaining scans: $e');
      return 0;
    }
  }

  void clearCache() {
    cachedUserId = null;
    cachedIsPremium = null;
    lastPremiumCheck = null;
  }
}
