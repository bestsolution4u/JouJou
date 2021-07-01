import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:joujou_lounge/bloc_data/category_list_bloc.dart';
import 'package:joujou_lounge/constant/config.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/category_model.dart';
import 'package:joujou_lounge/repository/meta_repository.dart';
import 'package:joujou_lounge/util/string_util.dart';
import 'package:joujou_lounge/widget/menu/category_list/child_category_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class ParentCategoryWidget extends StatefulWidget {
  final CategoryModel _category;
  final int _openedCategoryId;
  final Function(int) _onCategoryClicked, _onCategoryOpened;

  ParentCategoryWidget(this._category, this._onCategoryClicked, this._openedCategoryId, this._onCategoryOpened);

  @override
  _ParentCategoryWidgetState createState() => _ParentCategoryWidgetState();
}

class _ParentCategoryWidgetState extends State<ParentCategoryWidget>
    with SingleTickerProviderStateMixin {
  CategoryListBloc _categoryListBloc;
  Animation<double> sizeAnimation, arrowSizeAnimation;
  AnimationController expandController;

  @override
  void initState() {
    super.initState();
    _prepareAnimation();
    _categoryListBloc = CategoryListBloc();
    _categoryListBloc.fetchCategoriesByParent(widget._category.id);
  }

  @override
  void dispose() {
    _categoryListBloc.dispose();
    expandController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ParentCategoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._openedCategoryId == widget._category.id)
      expandController.forward();
    else
      expandController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildParent(),
        _buildChildren(),
      ],
    );
  }

  void _prepareAnimation() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    Animation curve =
        CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
    sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {});
    arrowSizeAnimation = Tween(begin: 0.0, end: 0.5).animate(curve)
      ..addListener(() {});
  }

  Widget _buildParent() {
    return FutureBuilder(
      future: MetaRepository.getMetaValue("main_category_color"),
      builder: (context, snapshot) {
        String strColor = snapshot.data;
        Color bgColor = StringUtils.hexToColor(strColor);
        if (bgColor == null) bgColor = Styles.appPrimaryColor;
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: StreamBuilder(
            stream: _categoryListBloc.categoryList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Container(
                      width: double.infinity,
                      height: Config.parentCategoryHeight,
                      color: bgColor,
                      child: Stack(
                        children: <Widget>[
                          _buildParentImage(),
                          _buildParentTitle(),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                List<CategoryModel> categories = snapshot.data;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onClickedParent(categories),
                    child: Container(
                      width: double.infinity,
                      height: Config.parentCategoryHeight,
                      color: bgColor,
                      child: Stack(
                        children: <Widget>[
                          _buildParentImage(),
                          _buildParentTitle(),
                          _buildArrowIcon(categories),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildParentImage() {
    return Positioned(
      top: 30,
      left: 0,
      right: 0,
      child: Center(
        child: FadeInImage(
          width: 80,
          height: 80,
          placeholder: AssetImage("assets/icon.png"),
          image: MemoryImage(base64Decode(widget._category.image)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildParentTitle() {
    return Positioned(
      top: 120,
      bottom: 20,
      left: 20,
      right: 20,
      child: Center(
        child: Text(
          isArabic() ? widget._category.titleAr : widget._category.title,
          style: TextStyle(color: Colors.white, fontSize: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }

  Widget _buildArrowIcon(List<CategoryModel> subCategories) {
    if (subCategories == null || subCategories.isEmpty) return Container();
    if (isArabic())
      return Positioned(
        top: 10,
        right: 10,
        child: RotationTransition(
        turns: arrowSizeAnimation,
        child: Icon(
        Icons.keyboard_arrow_down,
        size: 40,
        color: Colors.grey,
    ),
    ),
    );
    return Positioned(
      top: 10,
      left: 10,
      child: RotationTransition(
        turns: arrowSizeAnimation,
        child: Icon(
          Icons.keyboard_arrow_down,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildChildren() {
    return StreamBuilder(
      stream: _categoryListBloc.categoryList,
      builder: (context, snapshot) {
        List<CategoryModel> categories = snapshot.data;
        if (categories == null) {
          return Container();
        } else {
          return SizeTransition(
            sizeFactor: sizeAnimation,
            axisAlignment: -1,
            child: Column(
              children: _buildChildrenItems(categories),
            ),
          );
        }
      },
    );
  }

  List<Widget> _buildChildrenItems(List<CategoryModel> subCategories) {
    var widgets = List<Widget>();
    subCategories.forEach((element) {
      widgets.add(ChildCategoryWidget(element,
          (id) => _onChildClicked(id)));
    });
    return widgets;
  }

  void _onChildClicked(int id) {
    widget._onCategoryClicked(id);
  }

  void _onClickedParent(List<CategoryModel> subCategories) {
    if (subCategories != null && subCategories.isNotEmpty) {
      if (widget._openedCategoryId == widget._category.id)
        widget._onCategoryOpened(null);
      else
        widget._onCategoryOpened(widget._category.id);
    } else {
      widget._onCategoryClicked(widget._category.id);
    }
  }

  bool isArabic() {
    return EasyLocalization.of(context).locale.languageCode == "ar";
  }
}
