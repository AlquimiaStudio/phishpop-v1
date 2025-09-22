import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class ScanDatabaseService {
  static final ScanDatabaseService _instance = ScanDatabaseService._internal();
  factory ScanDatabaseService() => _instance;
  ScanDatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'scan_history.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_history (
        id TEXT PRIMARY KEY,
        scan_type TEXT NOT NULL,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        score REAL NOT NULL,
        timestamp TEXT NOT NULL,
        details TEXT,
        flagged_issues TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_timestamp ON scan_history(created_at DESC);
    ''');
  }

  Future<void> saveScan(ScanHistoryModel scan) async {
    final db = await database;
    
    final scanData = {
      'id': scan.id,
      'scan_type': scan.scanType,
      'title': scan.title,
      'date': scan.date,
      'status': scan.status,
      'score': scan.score,
      'timestamp': scan.timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'details': scan.details != null ? jsonEncode(scan.details!) : null,
      'flagged_issues': scan.flaggedIssues != null ? jsonEncode(scan.flaggedIssues!) : null,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    };

    await db.insert(
      'scan_history',
      scanData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _enforceLimit();
  }

  Future<List<ScanHistoryModel>> getRecentScans({int limit = 10}) async {
    final db = await database;
    
    final maps = await db.query(
      'scan_history',
      orderBy: 'created_at DESC',
      limit: limit,
    );

    return maps.map((map) => _mapToScanHistory(map)).toList();
  }

  Future<ScanHistoryModel?> getScanById(String id) async {
    final db = await database;
    
    final maps = await db.query(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return _mapToScanHistory(maps.first);
  }

  Future<void> deleteScan(String id) async {
    final db = await database;
    
    await db.delete(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllScans() async {
    final db = await database;
    await db.delete('scan_history');
  }

  Future<int> getScanCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM scan_history');
    return result.first['count'] as int;
  }

  Future<void> _enforceLimit({int maxRecords = 50}) async {
    final db = await database;
    
    final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM scan_history');
    final count = countResult.first['count'] as int;
    
    if (count > maxRecords) {
      final excessRecords = count - maxRecords;
      await db.rawDelete('''
        DELETE FROM scan_history 
        WHERE id IN (
          SELECT id FROM scan_history 
          ORDER BY created_at ASC 
          LIMIT ?
        )
      ''', [excessRecords]);
    }
  }

  ScanHistoryModel _mapToScanHistory(Map<String, dynamic> map) {
    return ScanHistoryModel(
      id: map['id'] as String,
      scanType: map['scan_type'] as String,
      title: map['title'] as String,
      date: map['date'] as String,
      status: map['status'] as String,
      score: map['score'] as double,
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp'] as String)
          : null,
      details: map['details'] != null 
          ? jsonDecode(map['details'] as String) as Map<String, dynamic>
          : null,
      flaggedIssues: map['flagged_issues'] != null 
          ? List<String>.from(jsonDecode(map['flagged_issues'] as String))
          : null,
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}