class DBTables {
  static const CATEGORY_TABLE = "Category";
  static const FOOD_TABLE = "Food";
  static const CART_TABLE = "Cart";
  static const FOOD_CATEGORY_TABLE = "FoodCategoryRelation";
  static const META_TABLE = "Meta";
}

class CategoryTableParams {
  static const String id = "id";
  static const String parent = "parent";
  static const String title = "title";
  static const String titleAr = "titleAr";
  static const String image = "image";
}

class FoodTableParams {
  static const String id = "id";
  static const String title = "title";
  static const String titleAr = "titleAr";
  static const String price = "price";
  static const String image = "image";
}

class FoodCategoryTableParams {
  static const String id = "id";
  static const String food = "food";
  static const String category = "category";
}

class CartTableParams {
  static const String id = "id";
  static const String food = "food";
  static const String title = "title";
  static const String titleAr = "titleAr";
  static const String price = "price";
  static const String qty = "qty";
}

class MetaTableParams {
  static const String id = "id";
  static const String key = "key";
  static const String value = "value";
}