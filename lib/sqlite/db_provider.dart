import 'package:joujou_lounge/constant/config.dart';
import 'package:joujou_lounge/constant/db_params.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  static Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  static initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Config.database);
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ${DBTables.CATEGORY_TABLE} ("
          "${CategoryTableParams.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "${CategoryTableParams.parent} INTEGER,"
          "${CategoryTableParams.title} TEXT,"
          "${CategoryTableParams.titleAr} TEXT,"
          "${CategoryTableParams.image} TEXT"
          ")");
      await db.execute("CREATE TABLE ${DBTables.FOOD_TABLE} ("
          "${FoodTableParams.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "${FoodTableParams.title} TEXT,"
          "${FoodTableParams.titleAr} TEXT,"
          "${FoodTableParams.price} REAL,"
          "${FoodTableParams.image} TEXT"
          ")");
      await db.execute("CREATE TABLE ${DBTables.FOOD_CATEGORY_TABLE} ("
          "${FoodCategoryTableParams.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "${FoodCategoryTableParams.food} INTEGER,"
          "${FoodCategoryTableParams.category} INTEGER"
          ")");
      await db.execute("CREATE TABLE ${DBTables.CART_TABLE} ("
          "${CartTableParams.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "${CartTableParams.food} INTEGER,"
          "${CartTableParams.title} TEXT,"
          "${CartTableParams.titleAr} TEXT,"
          "${CartTableParams.price} REAL,"
          "${CartTableParams.qty} INTEGER"
          ")");
      await db.execute("CREATE TABLE ${DBTables.META_TABLE} ("
          "${MetaTableParams.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "${MetaTableParams.key} TEXT,"
          "${MetaTableParams.value} TEXT"
          ")");
    });
  }
}