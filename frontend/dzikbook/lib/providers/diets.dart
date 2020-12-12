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
  List<Diet> _diets = [
    Diet(name: "Dieta 1", dietCalories: 30, foodList: [
      Food(
          id: "1",
          name: "ex1",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "2",
          name: "ex2",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "3",
          name: "ex3",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "4",
          name: "ex4",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "5",
          name: "ex5",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
    ]),
    Diet(name: "Dieta 2", dietCalories: 30, foodList: [
      Food(
          id: "1",
          name: "ex1",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "2",
          name: "ex2",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "3",
          name: "ex3",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "4",
          name: "ex4",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "5",
          name: "ex5",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
    ]),
    Diet(name: "Dieta 2", dietCalories: 30, foodList: [
      Food(
          id: "1",
          name: "ex1",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "2",
          name: "ex2",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "3",
          name: "ex3",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "4",
          name: "ex4",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "5",
          name: "ex5",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
    ]),
    Diet(name: "Dieta 2", dietCalories: 30, foodList: [
      Food(
          id: "1",
          name: "ex1",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "2",
          name: "ex2",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "3",
          name: "ex3",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "4",
          name: "ex4",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
      Food(
          id: "5",
          name: "ex5",
          calories: 3,
          weight: 4,
          protein: 90,
          carbs: 30,
          fat: 20),
    ]),
  ];

  List<Diet> get diets {
    return [..._diets];
  }

  Future<double> sumCalories(List<Food> food) async {
    return food
        .map((e) => e.calories)
        .reduce((value, element) => value + element);
  }

  Future<void> addDiet(Diet diet) async {
    _diets.add(diet);
    notifyListeners();
  }
}
