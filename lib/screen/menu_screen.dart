import 'package:flutter/material.dart';
import 'package:joujou_lounge/bloc_data/category_list_bloc.dart';
import 'package:joujou_lounge/bloc_data/food_list_bloc.dart';
import 'package:joujou_lounge/bloc_data/note_bloc.dart';
import 'package:joujou_lounge/constant/config.dart';
import 'package:joujou_lounge/constant/style.dart';
import 'package:joujou_lounge/model/category_model.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/repository/meta_repository.dart';
import 'package:joujou_lounge/widget/menu/category_list/category_list_widget.dart';
import 'package:joujou_lounge/widget/menu/food_item_widget.dart';
import 'package:joujou_lounge/widget/menu/staggered_gridview/flutter_staggered_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  CategoryListBloc _categoryListBloc;
  FoodListBloc _foodListBloc;
  NoteBloc _noteBloc;
  int _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = null;
    _categoryListBloc = CategoryListBloc();
    _categoryListBloc.fetchCategoriesByParent(null);
    _foodListBloc = FoodListBloc();
    _noteBloc = NoteBloc();
    _noteBloc.fetchNotes();
  }

  @override
  void dispose() {
    _categoryListBloc.dispose();
    //_foodListBloc.dispose();
    _noteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _foodListBloc.fetchFoodsByCategory(_selectedCategoryId);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildMenuPage(),
          buildLoading(),
        ],
      ),
    );
  }

  Widget buildMenuPage() {
    if (EasyLocalization.of(context).locale.languageCode == "ar")
      return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10),
            _buildItems(),
            SizedBox(width: 10),
            _buildCategories(),
          ],
        ),
      );
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCategories(),
          SizedBox(width: 10),
          _buildItems(),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget buildLoading() {
    return StreamBuilder(
      stream: _categoryListBloc.categoryList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return buildLoadingIndicator();
        else
          return StreamBuilder(
            stream: _foodListBloc.foodList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return buildLoadingIndicator();
              else
                return Container();
            },
          );
      },
    );
  }

  Widget buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor: new AlwaysStoppedAnimation<Color>(Styles.appPrimaryColor),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      width: Config.parentCategoryWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder(
            stream: _categoryListBloc.categoryList,
            builder: (context, snapshot) {
              List<CategoryModel> categories = snapshot.data;
              if (categories == null) return Container();
              return CategoryListWidget(
                categories: categories,
                onCategoryClicked: (categoryId) =>
                    _onCategorySelected(categoryId),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItems() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder(
                stream: _foodListBloc.foodList,
                builder: (context, snapshot) {
                  List<FoodModel> foods = snapshot.data;
                  if (foods == null || foods.isEmpty) {
                    return Container();
                  } else {
                    return GridView.builder(
                      primary: false,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: foods.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 100 / 150,
                          crossAxisCount: 2,
                          crossAxisSpacing: 20
                        ),
                        itemBuilder: (context, index) =>
                            _buildFoodItem(foods[index]));
                    return StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        isRTL: EasyLocalization.of(context).locale.languageCode == "ar",
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemCount: foods.length,
                        itemBuilder: (context, index) =>
                            _buildFoodItem(foods[index]),
                        staggeredTileBuilder: (_) => StaggeredTile.fit(1));
                  }
                },
              ),
            ),
          ),
          StreamBuilder(
            stream: _noteBloc.notes,
            builder: (context, snapshot) {
              if (snapshot.data == null || snapshot.data.isEmpty) {
                return Container();
              }
              return Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.data,
                  style: TextStyle(color: Styles.appPrimaryColor, fontSize: 20),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(FoodModel food) {
    return FoodItemWidget(food);
  }

  void _onCategorySelected(int categoryId) {
    if (_selectedCategoryId != categoryId) {
      setState(() {
        _selectedCategoryId = categoryId;
      });
    }
  }
}
