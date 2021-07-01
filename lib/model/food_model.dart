class FoodModel {
  final String _title;
  final String _titleAr;
  final int _id;
  final double _price;
  final String _image;

  const FoodModel({
    int id,
    String title,
    String titleAr,
    double price,
    String image,
})
  : _id = id,
  _title = title ?? "",
  _titleAr = titleAr ?? "",
  _price = price ?? 0,
  _image = image ?? "";

  double get price => _price;

  int get id => _id;

  String get title => _title;

  String get image => _image;

  String get titleAr => _titleAr;
}