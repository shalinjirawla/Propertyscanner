import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ReportModel {
  int? id;
  String? title;
  String? address;
  String? summary;
  String? scanVideoPath;
  String? pdfReport;
  String? damages;
  DateTime? createdAt;

  ReportModel({
    this.id,
    this.title,
    this.address,
    this.summary,
    this.scanVideoPath,
    this.pdfReport,
    this.damages,
    this.createdAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) => ReportModel(
    id: map['id'] as int?,
    title: map['title'] as String?,
    address: map['address'] as String?,
    summary: map['summary'] as String?,
    scanVideoPath: map['scanVideoPath'] as String?,
    pdfReport: map['pdfReport'] as String?,
    damages: map['damages'] as String?,
    createdAt: DateTime.parse(map["createdAt"]),
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'address': address,
      'summary': summary,
      'scanVideoPath': scanVideoPath,
      'pdfReport': pdfReport,
      'damages': damages,
      'createdAt': createdAt?.toIso8601String(),
    };
    if (id != null) map['id'] = id;
    return map;
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static const String _dbName = 'propertyScan.db';
  static const int _dbVersion = 1;
  static const String table = 'propertyScan';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute(_createTableQuery);
      },
      onOpen: (db) async {
        // Ensure table exists if DB was created earlier with different schema
        await db.execute(_createTableQuery);
        // Migration: Add damages column if not exists
        try {
          await db.execute("ALTER TABLE $table ADD COLUMN damages TEXT");
        } catch (e) {
          // Column likely already exists
        }
      },
    );
  }

  static const String _createTableQuery =
      '''
    CREATE TABLE IF NOT EXISTS $table(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      address TEXT,
      summary TEXT,
      scanVideoPath TEXT,
      pdfReport TEXT,
      damages TEXT,
      createdAt INTEGER
    )
  ''';

  Future<int> insertReport(ReportModel report) async {
    final db = await database;
    return await db.insert(table, report.toMap());
  }

  Future<List<ReportModel>> getAllReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: 'createdAt DESC',
    );

    return maps.map((m) => ReportModel.fromMap(m)).toList();
  }

  Future<int> updateReport(ReportModel report) async {
    final db = await database;
    return await db.update(
      table,
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  Future<int> deleteReport(int id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /// Development helper: delete DB file (useful to reset schema while developing)
  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _database = null;
  }
}
