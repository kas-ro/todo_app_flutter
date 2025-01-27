import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_app1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE todo (id INTEGER PRIMARY KEY, task TEXT, done INTEGER, createdAt INTEGER)'
        );
      },
    );
  }

  // INSERT DATA
  static Future<int> insertData(String task, int date) async {
    final db = await getDatabase();
    return await db.insert('todo', {'task': task, 'done': 0, 'createdAt': date});
  }

  // UPDATE DATA
  static Future<int> updateData(int id, int done) async {
    final db = await getDatabase();
    return await db.update('todo', {'done': done}, where: 'id=?', whereArgs: [id]);
  }

  // DELETE DATA
  static Future<int> deleteData(int id) async {
    final db = await getDatabase();
    return await db.delete('todo', where: 'id=?', whereArgs: [id]);
  }

  // LIST ALL DATA
  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await getDatabase();
    return await db.query('todo');
  }
}