import 'package:joujou_lounge/constant/db_params.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/sqlite/db_provider.dart';

class FoodRepository {
  static const String table = DBTables.FOOD_TABLE;

  static Future<FoodModel> fetchFoodDetail(int id) async {
    final db = await DBProvider.database;
    var resFood = await db.query(table,
        where: "${FoodTableParams.id} = ?",
        whereArgs: [id]);
    if (resFood.isNotEmpty) {
      return FoodModel(
          id: resFood.first[FoodTableParams.id],
          title: resFood.first[FoodTableParams.title],
          titleAr: resFood.first[FoodTableParams.titleAr],
          price: resFood.first[FoodTableParams.price],
          image: resFood.first[FoodTableParams.image]);
    } else return null;
  }

  static Future<List<FoodModel>> fetchFoodsByCategory(int category) async {
    List<FoodModel> foods = [];
    final db = await DBProvider.database;
    if (category == null) {
      var resFood = await db.query(table, limit: 20);
      if (resFood.isNotEmpty) {
        resFood.forEach((element) {
          foods.add(FoodModel(
              id: element[FoodTableParams.id],
              title: element[FoodTableParams.title],
              titleAr: element[FoodTableParams.titleAr],
              price: element[FoodTableParams.price],
              image: element[FoodTableParams.image]));
        });
      }
    } else {
      var res = await db.query(DBTables.FOOD_CATEGORY_TABLE,
          where: "${FoodCategoryTableParams.category} = ?",
          whereArgs: [category]);
      if (res.isNotEmpty) {
        for (int i = 0; i < res.length; i++) {
          var element = res[i];
          var resFood = await db.query(table,
              where: "${FoodTableParams.id} = ?",
              whereArgs: [element[FoodCategoryTableParams.food]]);
          if (resFood.isNotEmpty) {
            foods.add(FoodModel(
                id: resFood.first[FoodTableParams.id],
                title: resFood.first[FoodTableParams.title],
                titleAr: resFood.first[FoodTableParams.titleAr],
                price: resFood.first[FoodTableParams.price],
                image: resFood.first[FoodTableParams.image]));
          }
        }
      }
    }
    return foods;
  }

  static void insertFoodCategoryRelation(int food, int category) async {
    final db = await DBProvider.database;
    await db.rawInsert(
        "INSERT Into ${DBTables.FOOD_CATEGORY_TABLE} (${FoodCategoryTableParams.food}, ${FoodCategoryTableParams.category}) "
        "VALUES (?, ?)",
        [food, category]);
  }

  static void insertFood(FoodModel food) async {
    final db = await DBProvider.database;
    await db.rawInsert(
        "INSERT Into $table (${FoodTableParams.id}, ${FoodTableParams.title}, ${FoodTableParams.price}, ${FoodTableParams.image}) "
        "VALUES (?, ?, ?, ?)",
        [food.id, food.title, food.price, food.image]);
  }

  static void clearFoods() async {
    final db = await DBProvider.database;
    await db.delete(table);
  }

  static void clearFoodCategoryRelations() async {
    final db = await DBProvider.database;
    await db.delete(DBTables.FOOD_CATEGORY_TABLE);
  }
}
