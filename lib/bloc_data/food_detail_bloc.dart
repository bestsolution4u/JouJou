import 'package:joujou_lounge/bloc_data/base_bloc.dart';
import 'package:joujou_lounge/model/food_model.dart';
import 'package:joujou_lounge/repository/food_repository.dart';

class FoodDetailBloc extends BaseBloc<FoodModel> {

  Stream<FoodModel> get foodDetail => fetcher.stream;

  fetchFoodDetail(int id) async {
    FoodModel food = await FoodRepository.fetchFoodDetail(id);
    fetcher.sink.add(food);
  }
}