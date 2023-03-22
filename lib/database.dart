import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'item.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "items.db");

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: initDB,
    );

    return database;
  }

  void initDB(Database database, int version) async {
    await database.execute("""
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT,
        date INTEGER
      )
    """);
  }

  Future<List<Item>> getItems() async {
    final db = await database;

    var items = await db.query(
      "items",
      orderBy: "date DESC",
    );

    List<Item> itemList = items.isNotEmpty
        ? items.map((item) => Item.fromDatabase(item)).toList()
        : [];

    return itemList;
  }

  Future<Item> addItem(Item item) async {
    final db = await database;

    item.id = await db.insert(
      "items",
      item.toDatabase(),
    );

    return item;
  }

  Future<int> deleteItem(int id) async {
    final db = await database;

    int result = await db.delete(
      "items",
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }
}
