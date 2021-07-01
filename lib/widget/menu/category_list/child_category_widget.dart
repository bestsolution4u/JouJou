import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/category_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:joujou_lounge/repository/meta_repository.dart';
import 'package:joujou_lounge/util/string_util.dart';

class ChildCategoryWidget extends StatefulWidget {
  final CategoryModel _category;
  final Function(int) _onClick;

  ChildCategoryWidget(this._category, this._onClick);

  @override
  _ChildCategoryWidgetState createState() => _ChildCategoryWidgetState();
}

class _ChildCategoryWidgetState extends State<ChildCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MetaRepository.getMetaValue("sub_category_color"),
      builder: (context, snapshot) {
        String strColor = snapshot.data;
        Color bgColor = StringUtils.hexToColor(strColor);
        if (bgColor == null) bgColor = Styles.appSecondaryColor;
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onClicked(),
              child: Container(
                width: double.infinity,
                height: 120,
                color: bgColor,
                child: Stack(
                  children: <Widget>[
                    _buildCategoryImage(),
                    _buildCategoryTitle(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryImage() {
    if (isArabic())
      return Positioned(
        top: 20,
        left: 130,
        right: 20,
        bottom: 20,
        child: Center(
          child: FadeInImage(
            width: 60,
            height: 60,
            placeholder: AssetImage("assets/icon.png"),
            image: MemoryImage(base64Decode(widget._category.image)),
            fit: BoxFit.cover,
          ),
        ),
      );
    return Positioned(
      top: 20,
      left: 20,
      right: 130,
      bottom: 20,
      child: Center(
        child: FadeInImage(
          width: 60,
          height: 60,
          placeholder: AssetImage("assets/icon.png"),
          image: MemoryImage(base64Decode(widget._category.image)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCategoryTitle() {
    if (isArabic())
      return Positioned(
        top: 20,
        bottom: 20,
        left: 20,
        right: 90,
        child: Center(
          child: Text(
            widget._category.titleAr,
            style: TextStyle(color: Colors.white, fontSize: 16),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      );
    return Positioned(
      top: 20,
      bottom: 20,
      left: 90,
      right: 20,
      child: Center(
        child: Text(
          widget._category.title,
          style: TextStyle(color: Colors.white, fontSize: 16),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }

  void _onClicked() {
    widget._onClick(widget._category.id);
  }

  bool isArabic() {
    return EasyLocalization.of(context).locale.languageCode == "ar";
  }
}
