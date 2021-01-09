import 'dart:convert';

import 'package:dzikbook/models/HttpException.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../models/config.dart';
import 'workouts.dart';
import 'diets.dart';
import 'package:flutter/foundation.dart';

class DayPlans with ChangeNotifier {
  String token;
  String userId;
  List<Workout> workouts;
  List<Diet> diets;
  Dio dio = new Dio();

  final DateTime now = DateTime.now();
  Map<DateTime, List<Object>> _workoutPlans = {};
  Map<DateTime, List<Object>> _dietPlans = {};
  Map<DateTime, List<String>> _idWorkoutPlans = {};
  Map<DateTime, List<String>> _idDietPlans = {};

  Future<void> fetchPlans() async {
    final url = "$apiUrl/users/details/";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));

      final Map data = response.data;
      for (final elem in json.decode(data['workout_plans'])) {
        DateTime date = DateTime.parse(elem['date']);

        List<String> ids = [];
        for (final id in elem['ids']) {
          ids.add(id['id'].toString());
        }
        _idWorkoutPlans[date] = ids;
      }
      for (final elem in json.decode(data['diet_plans'])) {
        DateTime date = DateTime.parse(elem['date']);
        List<String> ids = [];
        for (final id in elem['ids']) {
          ids.add(id['id'].toString());
        }
        _idDietPlans[date] = ids;
      }
      await mapPlanIds();
      notifyListeners();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      throw HttpException(error.toString());
    }
  }

  Future<void> updatePlans(
    Map<DateTime, List<String>> newWorkoutPlans,
    Map<DateTime, List<String>> newDietPlans,
  ) async {
    final url = "$apiUrl/users/details/";
    final data = {
      'workout_plans': json.encode(newWorkoutPlans.entries
          .map((e) => {
                'date': e.key.toIso8601String(),
                'ids': e.value.map((e) => {'id': e}).toList(),
              })
          .toList()),
      'diet_plans': json.encode(newDietPlans.entries
          .map((e) => {
                'date': e.key.toIso8601String(),
                'ids': e.value.map((e) => {'id': e}).toList(),
              })
          .toList()),
    };
    FormData formData = FormData.fromMap(data);
    try {
      await dio.put(url,
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
    } catch (error, stackTrace) {
      print(error.toString());
      print(stackTrace.toString());
      throw HttpException(error.toString());
    }
  }

  Future<void> mapPlanIds() async {
    if (workouts.isNotEmpty) {
      _idWorkoutPlans.forEach((key, value) {
        _workoutPlans[key] = value
            .map<Object>((e) => workouts
                .where(
                  (element) => element.id == e,
                )
                .first)
            .toList();
      });
    }
    if (diets.isNotEmpty) {
      _idDietPlans.forEach((key, value) {
        _dietPlans[key] = value
            .map<Object>((e) => diets
                .where(
                  (element) => element.id == e,
                )
                .first)
            .toList();
      });
    }
  }

  Future<void> addWorkoutPlan(Workout plan, DateTime date) async {
    Map<DateTime, List<String>> newWorkoutPlans = _idWorkoutPlans;
    newWorkoutPlans.containsKey(date)
        ? newWorkoutPlans[date].add(plan.id)
        : newWorkoutPlans[date] = [plan.id];
    await updatePlans(newWorkoutPlans, _idDietPlans).then((value) {
      _idWorkoutPlans = newWorkoutPlans;
      _workoutPlans.containsKey(date)
          ? _workoutPlans[date].add(plan)
          : _workoutPlans[date] = [plan];
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      return 42;
    });
  }

  Future<void> addDietPlan(Diet plan, DateTime date) async {
    Map<DateTime, List<String>> newDietPlans = _idDietPlans;
    newDietPlans.containsKey(date)
        ? newDietPlans[date].add(plan.id)
        : newDietPlans[date] = [plan.id];
    await updatePlans(_idWorkoutPlans, newDietPlans).then((value) {
      _idDietPlans = newDietPlans;
      _dietPlans.containsKey(date)
          ? _dietPlans[date].add(plan)
          : _dietPlans[date] = [plan];
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      return 42;
    });
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
