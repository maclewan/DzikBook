import 'package:flutter/foundation.dart';

class Food {
  final String id;
  final String name;
  final double weight;
  final double protein;
  final double calories;
  final double carbs;
  final double fat;

  Food({
    @required this.id,
    @required this.name,
    @required this.weight,
    @required this.protein,
    @required this.calories,
    @required this.carbs,
    @required this.fat,
  });
}

class Diet {
  final String name;
  final int dietCalories;
  final List<Food> foodList;

  Diet({
    @required this.name,
    @required this.dietCalories,
    @required this.foodList,
  });
}

class Diets with ChangeNotifier {
  List<Diet> diets;
  Future<void> Function(List<Diet>) update;

  Future<double> sumCalories(List<Food> food) async {
    return food
        .map((e) => e.calories)
        .reduce((value, element) => value + element);
  }

  Future<void> addDiet(Diet diet) async {
    diets.add(diet);
    update(diets)
        .then(
      (value) => notifyListeners(),
    )
        .catchError((error) {
      diets.remove(diet);
      return 42;
    });
  }
}
