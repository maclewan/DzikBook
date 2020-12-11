import 'package:intl/intl.dart';

import './workouts.dart';
import './diets.dart';
import 'package:flutter/foundation.dart';
import "package:merge_map/merge_map.dart";

class dayPlan {
  final String id;
  final DateTime date;
  final Object plan;

  dayPlan({
    @required this.id,
    @required this.date,
    @required this.plan,
  });
}

class DayPlans with ChangeNotifier {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateTime now = DateTime.now();
  final Map<DateTime, List<Object>> _workoutPlans = {};
  final Map<DateTime, List<Object>> _dietPlans = {};

  void addWorkoutPlan(Workout plan, DateTime date) {
    _workoutPlans.containsKey(date)
        ? _workoutPlans[date].add(plan)
        : _workoutPlans[date] = [plan];
    // notifyListeners();
  }

  void addDietPlan(Diet plan, DateTime date) {
    _dietPlans.containsKey(date)
        ? _dietPlans[date].add(plan)
        : _dietPlans[date] = [plan];
    // notifyListeners();
  }

  Map<DateTime, List<Object>> get dietPlans {
    return {..._dietPlans};
  }

  Map<DateTime, List<Object>> get workoutPlans {
    return {..._workoutPlans};
  }

  Map<DateTime, List<Object>> mergeMaps(
      Map<DateTime, List<Object>> map1, Map<DateTime, List<Object>> map2) {
    Map<DateTime, List<Object>> result = Map<DateTime, List<Object>>.from(map1);

    map2.forEach((key, mapValue) {
      result[key] = result.containsKey(key) ? result[key] + mapValue : mapValue;
    });
    return result;
  }

  Map<DateTime, List<Object>> get allPlans {
    Map<DateTime, List<Object>> allPlans = mergeMaps(_workoutPlans, _dietPlans);
    return {...allPlans};
  }
}
