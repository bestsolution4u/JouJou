import 'package:joujou_lounge/constant/db_params.dart';
import 'package:joujou_lounge/model/cart_item_model.dart';
import 'package:joujou_lounge/model/cart_model.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/sqlite/db_provider.dart';

class CartRepository {
  static const String table = DBTables.CART_TABLE;

  static Future<CartModel> getCartContents() async {
    CartModel cart = CartModel();
    final db = await DBProvider.database;
    var res = await db.query(table);
    List<CartItemModel> list =
        res.isNotEmpty ? res.map((e) => CartItemModel.fromMap(e)).toList() : [];
    Map<int, CartItemModel> cartData = Map<int, CartItemModel>();
    list.forEach((element) {
      cartData[element.id] = element;
    });
    cart.cartFoods = cartData;
    return cart;
  }

  static void addToCart(FoodModel food, int qty) async {
    final db = await DBProvider.database;
    var res = await db.query(table,
        where: "${CartTableParams.food} = ?", whereArgs: [food.id]);
    if (res.isEmpty) {
      await db.rawInsert(
          "INSERT Into ${table} (${CartTableParams.food}, ${CartTableParams.title}, ${CartTableParams.price}, ${CartTableParams.qty}) "
          "VALUES (?, ?, ?, ?)",
          [food.id, food.title, food.price, qty]);
    } else {
      int updatedQty = res.first[CartTableParams.qty] + qty;
      if (updatedQty == 0) {
        await db.delete(table,
            where: "${CartTableParams.id} = ?",
            whereArgs: [res.first[CartTableParams.id]]);
      } else {
        await db.update(table, {"${CartTableParams.qty}": updatedQty},
            where: "${CartTableParams.id} = ?",
            whereArgs: [res.first[CartTableParams.id]]);
      }
    }
  }

  static void deleteCartItem(int id) async {
    final db = await DBProvider.database;
    await db.delete(table, where: "${CartTableParams.id} = ?", whereArgs: [id]);
  }

  static void clearCart() async {
    final db = await DBProvider.database;
    await db.delete(table);
  }
}
