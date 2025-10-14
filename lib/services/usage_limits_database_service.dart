import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UsageLimitsDatabaseService {
  static final UsageLimitsDatabaseService _instance =
      UsageLimitsDatabaseService._internal();
  factory UsageLimitsDatabaseService() => _instance;
  UsageLimitsDatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'usage_limits.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usage_limits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        scan_type TEXT NOT NULL,
        count INTEGER NOT NULL DEFAULT 0,
        reset_date TEXT NOT NULL,
        last_scan_date TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        UNIQUE(user_id, scan_type)
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_user_scan_type ON usage_limits(user_id, scan_type);
    ''');

    await db.execute('''
      CREATE INDEX idx_reset_date ON usage_limits(reset_date);
    ''');
  }

  Future<void> incrementScanCount(String userId, String scanType) async {
    final db = await database;
    final now = DateTime.now();
    final resetDate = _getNextResetDate(now);

    final existingRecord = await getScanCount(userId, scanType);

    if (existingRecord != null) {
      await db.update(
        'usage_limits',
        {
          'count': existingRecord['count'] + 1,
          'last_scan_date': now.toIso8601String(),
          'updated_at': now.millisecondsSinceEpoch,
        },
        where: 'user_id = ? AND scan_type = ?',
        whereArgs: [userId, scanType],
      );
    } else {
      await db.insert(
        'usage_limits',
        {
          'user_id': userId,
          'scan_type': scanType,
          'count': 1,
          'reset_date': resetDate.toIso8601String(),
          'last_scan_date': now.toIso8601String(),
          'created_at': now.millisecondsSinceEpoch,
          'updated_at': now.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<Map<String, dynamic>?> getScanCount(
    String userId,
    String scanType,
  ) async {
    final db = await database;

    final result = await db.query(
      'usage_limits',
      where: 'user_id = ? AND scan_type = ?',
      whereArgs: [userId, scanType],
    );

    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Map<String, int>> getAllScanCounts(String userId) async {
    final db = await database;

    final result = await db.query(
      'usage_limits',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    final counts = <String, int>{};
    for (final row in result) {
      counts[row['scan_type'] as String] = row['count'] as int;
    }

    return counts;
  }

  Future<bool> checkAndResetIfNeeded(String userId) async {
    final db = await database;
    final now = DateTime.now();

    final result = await db.query(
      'usage_limits',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    bool didReset = false;

    for (final row in result) {
      final resetDate = DateTime.parse(row['reset_date'] as String);

      if (now.isAfter(resetDate)) {
        final newResetDate = _getNextResetDate(now);

        await db.update(
          'usage_limits',
          {
            'count': 0,
            'reset_date': newResetDate.toIso8601String(),
            'updated_at': now.millisecondsSinceEpoch,
          },
          where: 'id = ?',
          whereArgs: [row['id']],
        );

        didReset = true;
      }
    }

    return didReset;
  }

  Future<void> resetAllCounters(String userId) async {
    final db = await database;
    final now = DateTime.now();
    final newResetDate = _getNextResetDate(now);

    await db.update(
      'usage_limits',
      {
        'count': 0,
        'reset_date': newResetDate.toIso8601String(),
        'updated_at': now.millisecondsSinceEpoch,
      },
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<DateTime?> getNextResetDate(String userId) async {
    final db = await database;

    final result = await db.query(
      'usage_limits',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return DateTime.parse(result.first['reset_date'] as String);
  }

  Future<void> deleteUserData(String userId) async {
    final db = await database;

    await db.delete(
      'usage_limits',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  DateTime _getNextResetDate(DateTime from) {
    if (from.day == 1 && from.hour == 0 && from.minute == 0) {
      return DateTime(from.year, from.month + 1, 1);
    }

    if (from.month == 12) {
      return DateTime(from.year + 1, 1, 1);
    } else {
      return DateTime(from.year, from.month + 1, 1);
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
