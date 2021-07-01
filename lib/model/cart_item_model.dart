import 'package:joujou_lounge/constant/db_params.dart';

class CartItemModel {
  final String _title;
  final String _titleAr;
  final int _id;
  final double _price;
  final int _qty;
  final int _food;

  CartItemModel(this._id, this._food, this._title, this._titleAr, this._price, this._qty);

  factory CartItemModel.fromMap(Map<String, dynamic> json) {
    return CartItemModel(
        json[CartTableParams.id],
        json[CartTableParams.food],
        json[CartTableParams.title],
        json[CartTableParams.titleAr],
        json[CartTableParams.price],
        json[CartTableParams.qty]);
  }

  int get qty => _qty;

  double get price => _price;

  int get id => _id;

  String get title => _title;

  int get food => _food;

  String get titleAr => _titleAr;
}
