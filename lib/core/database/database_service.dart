import 'package:drink_more/entities/local/reminder_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:drink_more/core/database/database_helper.dart';

class DatabaseService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<Database> get database async {
    return await _dbHelper.database;
  }

  Future<bool> hasTableData(String tableName) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT COUNT(*) as count FROM $tableName');
    return result.isNotEmpty && result.first['count'] > 0;
  }

  Future<void> insertWaterGoal(double dailyGoal) async {
    final db = await database;
    await db.insert(
      'WaterGoals',
      {'dailyGoal': dailyGoal},
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

  Future<void> insertReminder(List<ReminderModel> timesInSeconds) async {
    final db = await database;
    for (ReminderModel reminder in timesInSeconds) {
      final List<Map<String, dynamic>> maps = await db.query(
        'Reminders',
        where: 'time = ?',
        whereArgs: [reminder.seconds],
      );
      if (maps.isEmpty) {
        await db.insert(
          'Reminders',
          {'time': reminder.seconds},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<Map<String, dynamic>?> getWaterGoal() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('WaterGoals');
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

  // 取得所有飲水記錄
  Future<List<Map<String, dynamic>>> getAllWaterRecords() async {
    final db = await database;
    return await db.query('WaterRecords');
  }

  Future<List<ReminderModel>> getReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Reminders');

    return maps.map((map) {
      int id = map['id'] as int;
      int seconds = map['time'] as int;
      return ReminderModel(id: id, seconds: seconds);
    }).toList();
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

  // 更新提醒時間
  Future<void> updateReminder(int id, int newTime) async {
    final db = await database;
    await db.update(
      'Reminders',
      {'time': newTime},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 刪除提醒時間
  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete(
      'Reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
