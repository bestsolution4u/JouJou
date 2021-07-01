import 'package:joujou_lounge/bloc_data/base_bloc.dart';
import 'package:joujou_lounge/model/cart_item_model.dart';
import 'package:joujou_lounge/model/cart_model.dart';
import 'package:joujou_lounge/repository/cart_repository.dart';

class CartBloc extends BaseBloc<CartModel> {
  static CartBloc _cartBloc;
  Stream<CartModel> get cartContents => fetcher.stream;

  CartBloc();

  factory CartBloc.init() {
    if (_cartBloc == null) _cartBloc = CartBloc();
    return _cartBloc;
  }

  fetchCartContents() async {
    CartModel cart = await CartRepository.getCartContents();
    fetcher.sink.add(cart);
  }



  void clearCart() async {

  }
}