import 'package:flutter/material.dart';
import 'package:joujou_lounge/widget/menu/category_list/parent_category_widget.dart';
import 'package:meta/meta.dart';
import 'package:joujou_lounge/model/category_model.dart';

class CategoryListWidget extends StatefulWidget {

  final List<CategoryModel> _categories;
  final Function(int) _onCategoryClicked;

  CategoryListWidget({
    @required List<CategoryModel> categories,
    Function(int) onCategoryClicked,
})
  : _categories = categories,
  _onCategoryClicked = onCategoryClicked ?? null;

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();

}

class _CategoryListWidgetState extends State<CategoryListWidget> {

  int _openedCategory;

  @override
  void initState() {
    super.initState();
    _openedCategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: _buildParentCategories(),
      ),
    );
  }

  List<Widget> _buildParentCategories() {
    var widgets = List<ParentCategoryWidget>();
    widget._categories.forEach((element) {
      widgets.add(ParentCategoryWidget(element, (id) => onCategoryClicked(id), _openedCategory, (id) => _onCategoryOpened(id)));
    });
    return widgets;
  }

  void onCategoryClicked(int id) {
    for (int i = 0; i < widget._categories.length; i++) {
      if (id == widget._categories[i].id) {
        setState(() {
          _openedCategory = null;
        });
      }
    }
    widget._onCategoryClicked(id);
  }

  void _onCategoryOpened(int id) {
    if (_openedCategory != id) {
      setState(() {
        _openedCategory = id;
      });
    }
  }
}
