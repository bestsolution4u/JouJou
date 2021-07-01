import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joujou_lounge/bloc_data/cart_bloc.dart';
import 'package:joujou_lounge/bloc_data/food_detail_bloc.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/cart_item_model.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/repository/cart_repository.dart';
import 'package:easy_localization/easy_localization.dart';

class CartItemWidget extends StatefulWidget {

  final CartItemModel _cartItem;

  CartItemWidget(this._cartItem);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {

  CartBloc _cartBloc = CartBloc.init();
  FoodDetailBloc _foodBloc;

  @override
  void initState() {
    super.initState();
    _foodBloc = FoodDetailBloc();

  }

  @override
  void dispose() {
    _foodBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _foodBloc.fetchFoodDetail(widget._cartItem.food);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      child: isArabic() ? buildRTL() : buildLTR(),
    );
  }

  Widget buildLTR() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 0,
            ),
          ),
          child: StreamBuilder(
            stream: _foodBloc.foodDetail,
            builder: (context, snapshot) {
              FoodModel food = snapshot.data;
              if (food == null) {
                return Container(
                  width: 160,
                  height: 120,
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                return Image.memory(
                  base64Decode(food.image),
                  width: 160,
                  height: 120,
                  fit: BoxFit.cover,
                );
              }
            },
          ),
        ),
        SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text(widget._cartItem.title, style: TextStyle(color: Styles.appPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1, softWrap: false, overflow: TextOverflow.fade,),
              SizedBox(height: 15),
              Text("${widget._cartItem.qty} x ${widget._cartItem.price} SAR", style: TextStyle(color: Styles.appPrimaryColor, fontSize: 18),),
              SizedBox(height: 15),
              Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.3))
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _onDecrease();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.remove, color: Colors.black, size: 24,),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "${widget._cartItem.qty}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _onIncrease();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.add, color: Colors.black, size: 24,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20,),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _deleteItem(),
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.clear, color: Styles.appSecondaryColor, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRTL() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _deleteItem(),
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.clear, color: Styles.appSecondaryColor, size: 32),
            ),
          ),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: 10),
              Text(widget._cartItem.titleAr?? "", style: TextStyle(color: Styles.appPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold), maxLines: 1, softWrap: false, overflow: TextOverflow.fade,),
              SizedBox(height: 15),
              Text(tr("sar") + "${widget._cartItem.price}  x  ${widget._cartItem.qty}", style: TextStyle(color: Styles.appPrimaryColor, fontSize: 18),),
              SizedBox(height: 15),
              Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.3))
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _onIncrease();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.add, color: Colors.black, size: 24,),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "${widget._cartItem.qty}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _onDecrease();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.remove, color: Colors.black, size: 24,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 40),
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 0,
            ),
          ),
          child: StreamBuilder(
            stream: _foodBloc.foodDetail,
            builder: (context, snapshot) {
              FoodModel food = snapshot.data;
              if (food == null) {
                return Container(
                  width: 160,
                  height: 120,
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                return Image.memory(
                  base64Decode(food.image),
                  width: 160,
                  height: 120,
                  fit: BoxFit.cover,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  void _deleteItem() async {
    await CartRepository.deleteCartItem(widget._cartItem.id);
    _cartBloc.fetchCartContents();
  }

  void _onDecrease() async {
    FoodModel food = FoodModel(id: widget._cartItem.food);
    await CartRepository.addToCart(food, -1);
    _cartBloc.fetchCartContents();
  }

  void _onIncrease() async {
    FoodModel food = FoodModel(id: widget._cartItem.food);
    await CartRepository.addToCart(food, 1);
    _cartBloc.fetchCartContents();
  }

  bool isArabic() {
    return EasyLocalization.of(context).locale.languageCode == "ar";
  }
}
