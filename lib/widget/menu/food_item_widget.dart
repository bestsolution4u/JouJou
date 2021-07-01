import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:joujou_lounge/bloc_data/cart_bloc.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/repository/cart_repository.dart';
import 'package:joujou_lounge/widget/cart/add_cart_button.dart';
import 'package:easy_localization/easy_localization.dart';

class FoodItemWidget extends StatefulWidget {

  final FoodModel _food;

  FoodItemWidget(this._food);

  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {

  CartBloc _cartBloc = CartBloc.init();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: isArabic() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 270,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey.withOpacity(0.3),
                  width: 0,
                ),
              ),
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage("assets/icon.png"),
                image: MemoryImage(base64Decode(widget._food.image)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(isArabic() ? widget._food.titleAr : widget._food.title, style: TextStyle(color: Colors.black, fontSize: 22), maxLines: 1, softWrap: false, overflow: TextOverflow.fade,),
          SizedBox(height: 5),
          Row(
            children: <Widget>[
              isArabic() ? AddCartButton(
                onClicked: () => _addToCart(),
              ) : Text("${widget._food.price} SAR", style: TextStyle(color: Styles.appThirdColor, fontSize: 22),),
              Expanded(child: Container(),),
              isArabic() ? Text("${widget._food.price} ر.س ", style: TextStyle(color: Styles.appThirdColor, fontSize: 22),) : AddCartButton(
                onClicked: () => _addToCart(),
              )
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  bool isArabic() {
    return EasyLocalization.of(context).locale.languageCode == "ar";
  }

  void _addToCart() async {
    await CartRepository.addToCart(widget._food, 1);
    _cartBloc.fetchCartContents();
  }
}
