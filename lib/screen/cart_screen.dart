import 'package:flutter/material.dart';
import 'package:joujou_lounge/bloc_data/cart_bloc.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/cart_model.dart';
import 'package:joujou_lounge/repository/cart_repository.dart';
import 'package:joujou_lounge/widget/cart/cart_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc _cartBloc = CartBloc.init();

  @override
  void initState() {
    super.initState();
    _cartBloc.fetchCartContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 120),
                    Text(
                      tr("orders"),
                      style: TextStyle(
                          color: Styles.appPrimaryColor,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 60),
                    StreamBuilder(
                      stream: _cartBloc.cartContents,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          CartModel cart = snapshot.data;
                          return Text(plural("total", cart.getTotalPrice(),
                              format: NumberFormat.currency(
                                  locale: Intl.defaultLocale, symbol: tr("sar"))), style: TextStyle(color: Styles.appSecondaryColor, fontSize: 28, fontWeight: FontWeight.bold),);
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    StreamBuilder(
                      stream: _cartBloc.cartContents,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          CartModel cart = snapshot.data;
                          return ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => CartItemWidget(cart.cartFoods.values.toList()[index]),
                              separatorBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 80),
                                    child: Divider(height: 20),
                                  ),
                              itemCount: cart.cartFoods.length);
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SizedBox(height: 40,),
                  ],
                ),
              ),
            ),
            _buildClearButton()
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return StreamBuilder(
      stream: _cartBloc.cartContents,
      builder: (context, snapshot) {
        CartModel cart = snapshot.data;
        if (cart == null) return Container();
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5.0,
              offset: Offset(0, 0),
            ),
          ], color: Colors.white),
          child: Center(
            child: ButtonTheme(
              minWidth: 320,
              height: 60,
              child: RaisedButton(
                onPressed: () => _onClearCart(),
                child: Text(
                  tr("clear_order"),
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                color: Styles.appSecondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onClearCart() async {
    await CartRepository.clearCart();
    _cartBloc.fetchCartContents();
  }
}
