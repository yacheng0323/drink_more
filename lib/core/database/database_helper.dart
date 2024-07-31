import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'drink_more.db');

    await Directory(dbPath).create(recursive: true);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE WaterGoals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        dailyGoal REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE WaterRecords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        amount REAL NOT NULL,
        FOREIGN KEY (date) REFERENCES WaterGoals(date) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        time TEXT NOT NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE StageGoals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL NOT NULL
    )
  ''');
  }
}
