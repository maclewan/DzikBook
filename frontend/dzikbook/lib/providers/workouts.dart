import 'package:flutter/foundation.dart';

class Exercise {
  final String id;
  final String name;
  final int series;
  final int reps;
  final int breakTime;

  Exercise({
    @required this.id,
    @required this.name,
    @required this.series,
    @required this.reps,
    @required this.breakTime,
  });
}

class Workout {
  final String id;
  final String name;
  final int workoutLength;
  final List<Exercise> exercises;

  Workout({
    @required this.id,
    @required this.name,
    @required this.workoutLength,
    @required this.exercises,
  });
}

class Workouts with ChangeNotifier {
  Future<void> Function(List<Workout>) update;
  List<dynamic> workouts;

  Future<int> countWorkoutLength(List<Exercise> exercises) async {
    return exercises
        .map((e) => e.breakTime * e.series)
        .reduce((value, element) => value + element);
  }

  Future<void> addWorkout(Workout newWorkout) async {
    workouts.add(newWorkout);
    update(workouts)
        .then(
      (value) => notifyListeners(),
    )
        .catchError((error) {
      workouts.remove(newWorkout);
      return 42;
    });
  }
}
