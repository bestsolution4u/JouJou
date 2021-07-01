import 'package:joujou_lounge/bloc_data/base_bloc.dart';
import 'package:joujou_lounge/model/category_model.dart';
import 'package:joujou_lounge/repository/category_repository.dart';

class CategoryListBloc extends BaseBloc<List<CategoryModel>> {

  Stream<List<CategoryModel>> get categoryList => fetcher.stream;

  fetchCategoriesByParent(int parent) async {
    List<CategoryModel> categories = await CategoryRepository.fetchCategoriesByParent(parent);
    fetcher.sink.add(categories);
  }
}