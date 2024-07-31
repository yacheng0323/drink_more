import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:drink_more/core/database/database_helper.dart';

class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<Database> get database async {
    return await _dbHelper.database;
  }

  Future<void> insertWaterGoal(DateTime date, double dailyGoal) async {
    final db = await database;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    await db.insert(
      'WaterGoals',
      {'date': formattedDate, 'dailyGoal': dailyGoal},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertStageGoal(double amount) async {
    final db = await database;
    await db.insert(
      'StageGoals',
      {'amount': amount},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertWaterRecord(DateTime date, double amount) async {
    final db = await database;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    await db.insert(
      'WaterRecords',
      {'date': formattedDate, 'amount': amount},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertReminder(String time) async {
    final db = await database;
    await db.insert(
      'Reminders',
      {'time': time},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getWaterGoal(DateTime date) async {
    final db = await database;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final List<Map<String, dynamic>> maps = await db.query(
      'WaterGoals',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getWaterRecords(DateTime date) async {
    final db = await database;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return await db.query(
      'WaterRecords',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
  }

  Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await database;
    return await db.query('Reminders');
  }

  Future<double> getTotalWaterAmount(DateTime date) async {
    final db = await database;
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final List<Map<String, dynamic>> maps = await db.query(
      'WaterRecords',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );

    double totalAmount = 0.0;
    for (var map in maps) {
      totalAmount += map['amount'];
    }
    return totalAmount;
  }

  Future<List<Map<String, dynamic>>> getStageGoals() async {
    final db = await database;
    return await db.query('StageGoals');
  }
}
