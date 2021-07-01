import 'package:joujou_lounge/bloc_data/base_bloc.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/repository/food_repository.dart';

class FoodListBloc extends BaseBloc<List<FoodModel>> {

  Stream<List<FoodModel>> get foodList => fetcher.stream;

  fetchFoodsByCategory(int category) async {
    List<FoodModel> foods = await FoodRepository.fetchFoodsByCategory(category);
    print("Food list count: ${foods.length}");
    fetcher.sink.add(foods);
  }
}