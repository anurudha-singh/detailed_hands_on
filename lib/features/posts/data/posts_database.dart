import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'post_model.dart';

class PostsDatabase {
  static final PostsDatabase _instance = PostsDatabase._internal();
  factory PostsDatabase() => _instance;
  PostsDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'posts.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        isSync INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');
  }

  // Insert a post
  Future<int> insertPost(PostModel post) async {
    final db = await database;
    return await db.insert('posts', post.toMap());
  }

  // Get all posts
  Future<List<PostModel>> getAllPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => PostModel.fromMap(maps[i]));
  }

  // Get unsynced posts (for offline sync)
  Future<List<PostModel>> getUnsyncedPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'isSync = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => PostModel.fromMap(maps[i]));
  }

  // Update post
  Future<int> updatePost(PostModel post) async {
    final db = await database;
    return await db.update(
      'posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  // Delete post
  Future<int> deletePost(int id) async {
    final db = await database;
    return await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all posts (useful for testing)
  Future<int> clearAllPosts() async {
    final db = await database;
    return await db.delete('posts');
  }

  // Insert multiple posts (for API data)
  Future<void> insertPosts(List<PostModel> posts) async {
    final db = await database;
    final batch = db.batch();

    for (PostModel post in posts) {
      batch.insert(
        'posts',
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  // Mark post as synced
  Future<int> markPostAsSynced(int localId, int serverId) async {
    final db = await database;
    return await db.update(
      'posts',
      {'id': serverId, 'isSync': 1},
      where: 'id = ?',
      whereArgs: [localId],
    );
  }

  // Check if posts table has data
  Future<bool> hasData() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM posts');
    final count = result.first['count'] as int;
    return count > 0;
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
