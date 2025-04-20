import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/recipe_model.dart';

class DatabaseHelper {
  static const _dbName = 'recipes.db';
  static const _dbVersion = 1;
  static const _tableName = 'favorites';

  static Database? _database;

  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableName (
      id INTEGER PRIMARY KEY,
      likes TEXT,
      title TEXT,
      image TEXT,
      readyInMinutes INTEGER,
      ingredients TEXT,
      instructions TEXT
    )
  ''');
  }

  Future<void> insertRecipe(RecipeModel recipe) async {
    final db = await database;
    await db.insert(
      _tableName,
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecipeModel>> getFavoriteRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => RecipeModel.fromMap(maps[i]));
  }

  Future<void> deleteRecipe(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
