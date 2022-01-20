import 'package:fancy_todo_flutter/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              title STRING, 
              note STRING, 
              isCompleted INTEGER, 
              date STRING, 
              startTime STRING, 
              endTime STRING, 
              color INTEGER, 
              remind INTEGER, 
              repeat STRING
            )
            ''');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static update(Task? task) async {
    await _db!.update(_tableName, task!.toJson(), where: "id = ?", whereArgs: [task.id]);
  }

  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static updateIsCompleted(int id, int isCompleted) async {
    await _db!.rawUpdate('UPDATE $_tableName SET isCompleted = ? WHERE id = ?', [isCompleted, id]);
  }
}
