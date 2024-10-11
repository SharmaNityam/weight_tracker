import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weight_tracker/models/weight_entry.dart';

class WeightRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'weight_tracker.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE weights(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          weight REAL
        )
      ''');
    });
  }

  Future<List<WeightEntry>> getWeights() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('weights', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => WeightEntry.fromMap(maps[i]));
  }

  Future<void> addWeight(WeightEntry entry) async {
    final db = await database;
    await db.insert('weights', entry.toMap());
  }

  Future<void> deleteWeight(WeightEntry entry) async {
    final db = await database;
    await db.delete('weights', where: 'id = ?', whereArgs: [entry.id]);
  }
}
