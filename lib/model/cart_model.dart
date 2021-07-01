import 'package:joujou_lounge/model/cart_item_model.dart';

class CartModel {
  Map<int, CartItemModel> _cartFoods = Map<int, CartItemModel>();

  CartModel();

  Map<int, CartItemModel> get cartFoods => _cartFoods;

  set cartFoods(Map<int, CartItemModel> value) {
    _cartFoods = value;
  }

  int getTotalItemCount() {
    int result = 0;
    _cartFoods.forEach((key, value) {
      result += value.qty;
    });
    return result;
  }

  double getTotalPrice() {
    double result = 0;
    _cartFoods.forEach((key, value) {
      int qty = value.qty;
      result += qty * value.price;
    });
    return result;
  }
}