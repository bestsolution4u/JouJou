import 'package:joujou_lounge/constant/db_params.dart';
import 'package:joujou_lounge/model/category_model.dart';
import 'package:joujou_lounge/sqlite/db_provider.dart';

class CategoryRepository {
  static const String table = DBTables.CATEGORY_TABLE;

  static Future<List<CategoryModel>> fetchCategoriesByParent(int parent) async {
    List<CategoryModel> categories = [];
    final db = await DBProvider.database;
    if (parent == null) {
      var res = await db.rawQuery("SELECT * FROM $table WHERE parent IS NULL");
      if (res.isNotEmpty) {
        res.forEach((element) {
          categories.add(CategoryModel(
            id: element[CategoryTableParams.id],
            title: element[CategoryTableParams.title],
            titleAr: element[CategoryTableParams.titleAr],
            parentId: element[CategoryTableParams.parent],
            image: element[CategoryTableParams.image],
          ));
        });
      }
    } else {
      var res = await db.query(table,
          where: "${CategoryTableParams.parent} = ?", whereArgs: [parent]);
      if (res.isNotEmpty) {
        res.forEach((element) {
          categories.add(CategoryModel(
            id: element[CategoryTableParams.id],
            title: element[CategoryTableParams.title],
            titleAr: element[CategoryTableParams.titleAr],
            parentId: element[CategoryTableParams.parent],
            image: element[CategoryTableParams.image],
          ));
        });
      }
    }
    
    return categories;
  }

  static void insertCategory(CategoryModel category) async {
    final db = await DBProvider.database;
    await db.rawInsert(
        "INSERT Into $table (${CategoryTableParams.id}, ${CategoryTableParams.title}, ${CategoryTableParams.parent}, ${CategoryTableParams.image}) "
        "VALUES (?, ?, ?, ?)",
        [category.id, category.title, category.parentId, category.image]);
  }

  static void clearCategories() async {
    final db = await DBProvider.database;
    await db.delete(table);
  }
}
