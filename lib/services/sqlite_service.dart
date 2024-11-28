import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/tasks.dart';

class SQLiteService {
  SQLiteService();

  final Future<Database> database = (() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tasks_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isDone BOOLEAN, data TEXT)',
        );
      },
      version: 1,
    );
  })();

  Future<int> insertTask(Tasks task) async {
    final db = await database;
    int taskId = await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Task inserted with id: $taskId');
    return taskId;
  }

  Future<List<Tasks>> tasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Tasks.fromMap(maps[i]);
    });
  }

  Future<Tasks> getTaskById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Tasks.fromMap(maps.first);
  }

  Future<void> updateTask(Tasks task) async {
    if (task.id == null) {
      throw Exception('Task id is null');
    }

    int id = task.id!;

    Tasks existingTask = await getTaskById(id);

    if (existingTask.id == null) {
      throw Exception('Task not found');
    }

    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete('tasks');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
