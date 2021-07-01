class CategoryModel {
  final String _title;
  final int _id;
  final int _parentId;
  final String _image;
  final String _titleAr;

  const CategoryModel({
    int id,
    String title,
    int parentId,
    String image,
    String titleAr,
})
  : _id = id,
  _title = title ?? "",
  _titleAr = titleAr ?? "",
  _parentId = parentId ?? null,
  _image = image ?? "";

  int get parentId => _parentId;

  int get id => _id;

  String get title => _title;

  String get image => _image;

  String get titleAr => _titleAr;
}