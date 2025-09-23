import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/persistent_stats_model.dart';

class PersistentStatsDatabaseService {
  static Database? _database;
  static const String _dbName = 'persistent_stats.db';
  static const int _dbVersion = 1;

  // Table names
  static const String _statsTable = 'persistent_stats';
  static const String _threatCountersTable = 'threat_counters';

  // Singleton pattern
  static final PersistentStatsDatabaseService _instance =
      PersistentStatsDatabaseService._internal();
  factory PersistentStatsDatabaseService() => _instance;
  PersistentStatsDatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Create persistent_stats table
    await db.execute('''
      CREATE TABLE $_statsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_scans INTEGER NOT NULL DEFAULT 0,
        safe_scans INTEGER NOT NULL DEFAULT 0,
        warning_scans INTEGER NOT NULL DEFAULT 0,
        threat_scans INTEGER NOT NULL DEFAULT 0,
        url_scans INTEGER NOT NULL DEFAULT 0,
        text_scans INTEGER NOT NULL DEFAULT 0,
        qr_scans INTEGER NOT NULL DEFAULT 0,
        wifi_scans INTEGER NOT NULL DEFAULT 0,
        total_confidence REAL NOT NULL DEFAULT 0.0,
        last_scan_date TEXT,
        last_scan_type TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create threat_counters table
    await db.execute('''
      CREATE TABLE $_threatCountersTable (
        threat_name TEXT PRIMARY KEY,
        count INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Insert initial stats row
    final now = DateTime.now().toIso8601String();
    await db.insert(_statsTable, {
      'total_scans': 0,
      'safe_scans': 0,
      'warning_scans': 0,
      'threat_scans': 0,
      'url_scans': 0,
      'text_scans': 0,
      'qr_scans': 0,
      'wifi_scans': 0,
      'total_confidence': 0.0,
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here if needed in the future
  }

  // CRUD operations for PersistentStats
  Future<PersistentStatsModel> getStats() async {
    final db = await database;
    final results = await db.query(_statsTable, limit: 1);

    if (results.isEmpty) {
      // If no stats exist, create initial row
      final now = DateTime.now().toIso8601String();
      final id = await db.insert(_statsTable, {
        'total_scans': 0,
        'safe_scans': 0,
        'warning_scans': 0,
        'threat_scans': 0,
        'url_scans': 0,
        'text_scans': 0,
        'qr_scans': 0,
        'wifi_scans': 0,
        'total_confidence': 0.0,
        'created_at': now,
        'updated_at': now,
      });

      return PersistentStatsModel.fromJson({
        'id': id,
        'total_scans': 0,
        'safe_scans': 0,
        'warning_scans': 0,
        'threat_scans': 0,
        'url_scans': 0,
        'text_scans': 0,
        'qr_scans': 0,
        'wifi_scans': 0,
        'total_confidence': 0.0,
        'last_scan_date': null,
        'last_scan_type': null,
        'created_at': now,
        'updated_at': now,
      });
    }

    return PersistentStatsModel.fromJson(results.first);
  }

  Future<void> updateStats(PersistentStatsModel stats) async {
    final db = await database;
    await db.update(
      _statsTable,
      stats.toJson(),
      where: 'id = ?',
      whereArgs: [stats.id],
    );
  }

  Future<void> incrementScanStats({
    required String scanType,
    required String status,
    required double confidence,
    required String scanDate,
  }) async {
    final db = await database;
    final stats = await getStats();

    // Prepare increments
    final increments = <String, dynamic>{
      'total_scans': stats.totalScans + 1,
      'total_confidence': stats.totalConfidence + confidence,
      'last_scan_date': scanDate,
      'last_scan_type': scanType,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Increment status counters
    switch (status.toLowerCase()) {
      case 'safe':
        increments['safe_scans'] = stats.safeScans + 1;
        break;
      case 'warning':
        increments['warning_scans'] = stats.warningScans + 1;
        break;
      case 'threat':
        increments['threat_scans'] = stats.threatScans + 1;
        break;
    }

    // Increment scan type counters
    switch (scanType.toLowerCase()) {
      case 'url':
        increments['url_scans'] = stats.urlScans + 1;
        break;
      case 'text':
        increments['text_scans'] = stats.textScans + 1;
        break;
      case 'qr_url':
      case 'qr_wifi':
        increments['qr_scans'] = stats.qrScans + 1;
        break;
      case 'wifi':
        increments['wifi_scans'] = stats.wifiScans + 1;
        break;
    }

    await db.update(
      _statsTable,
      increments,
      where: 'id = ?',
      whereArgs: [stats.id],
    );
  }

  // CRUD operations for ThreatCounters
  Future<List<ThreatCounterModel>> getThreatCounters() async {
    final db = await database;
    final results = await db.query(_threatCountersTable, orderBy: 'count DESC');

    return results.map((json) => ThreatCounterModel.fromJson(json)).toList();
  }

  Future<List<String>> getTopThreats({int limit = 3}) async {
    final db = await database;
    final results = await db.query(
      _threatCountersTable,
      orderBy: 'count DESC',
      limit: limit,
    );

    return results.map((row) => row['threat_name'] as String).toList();
  }

  Future<void> incrementThreatCounter(String threatName) async {
    final db = await database;

    // Try to update existing counter
    final updateCount = await db.rawUpdate(
      '''
      UPDATE $_threatCountersTable 
      SET count = count + 1 
      WHERE threat_name = ?
    ''',
      [threatName],
    );

    // If no existing counter, create new one
    if (updateCount == 0) {
      await db.insert(_threatCountersTable, {
        'threat_name': threatName,
        'count': 1,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<void> addThreatIssues(List<String> issues) async {
    if (issues.isEmpty) return;

    for (final issue in issues) {
      await incrementThreatCounter(issue);
    }
  }

  Future<void> resetStats() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Reset stats table
    await db.update(_statsTable, {
      'total_scans': 0,
      'safe_scans': 0,
      'warning_scans': 0,
      'threat_scans': 0,
      'url_scans': 0,
      'text_scans': 0,
      'qr_scans': 0,
      'wifi_scans': 0,
      'total_confidence': 0.0,
      'last_scan_date': null,
      'last_scan_type': null,
      'updated_at': now,
    });

    // Clear threat counters
    await db.delete(_threatCountersTable);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
