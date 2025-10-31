import 'package:detailed_hands_on/features/todo_with_filter/data/todo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  static final String tableTodos = 'todos';
  static final TodoDatabase _todoDatabase =
      TodoDatabase._internal(); //This is just a placeholder to create the class instance
  TodoDatabase._internal();

  Database? _database;

  factory TodoDatabase() {
    return _todoDatabase;
  }
  Future<void> initDB() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableTodos(id TEXT PRIMARY KEY, title TEXT, isDone INTEGER, createdAt TEXT)',
        );
      },
      version: 1,
    );
  }

  Database get database {
    if (_database == null) {
      initDB();
    }
    return _database!;
  }

  closeDB() async {
    final db = database;
    db.close();
  }

  insertTodo(TodoModel todo) async {
    final db = database;
    await db.insert(
      TodoDatabase.tableTodos,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TodoModel>> getTodos() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query(tableTodos);
    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }

  deleteTodo(TodoModel todo) async {
    final db = database;
    await db.delete(
      tableTodos,
      where: 'title = ? AND createdAt = ?',
      whereArgs: [todo.title, todo.createdAt.toIso8601String()],
    );
  }

  updateTodo(TodoModel todo) async {
    final db = database;
    await db.update(
      tableTodos,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}
