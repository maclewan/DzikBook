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
  final String name;
  final int workoutLength;
  final List<Exercise> exercises;

  Workout({
    @required this.name,
    @required this.workoutLength,
    @required this.exercises,
  });
}

class Workouts with ChangeNotifier {
  List<Workout> _workouts = [
    Workout(name: "Trening 1", workoutLength: 30, exercises: [
      Exercise(id: "1", name: "ex1", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "2", name: "ex2", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "3", name: "ex3", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "4", name: "ex4", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "5", name: "ex5", series: 3, reps: 4, breakTime: 90),
    ]),
    Workout(name: "Trening 2", workoutLength: 30, exercises: [
      Exercise(id: "1", name: "ex1", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "2", name: "ex2", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "3", name: "ex3", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "4", name: "ex4", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "5", name: "ex5", series: 3, reps: 4, breakTime: 90),
    ]),
    Workout(name: "Trening 2", workoutLength: 30, exercises: [
      Exercise(id: "1", name: "ex1", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "2", name: "ex2", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "3", name: "ex3", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "4", name: "ex4", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "5", name: "ex5", series: 3, reps: 4, breakTime: 90),
    ]),
    Workout(name: "Trening 2", workoutLength: 30, exercises: [
      Exercise(id: "1", name: "ex1", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "2", name: "ex2", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "3", name: "ex3", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "4", name: "ex4", series: 3, reps: 4, breakTime: 90),
      Exercise(id: "5", name: "ex5", series: 3, reps: 4, breakTime: 90),
    ]),
  ];

  List<Workout> get workouts {
    return [..._workouts];
  }

  Future<int> countWorkoutLength(List<Exercise> exercises) async {
    return exercises
        .map((e) => e.breakTime * e.series)
        .reduce((value, element) => value + element);
  }

  Future<void> addWorkout(Workout newWorkout) async {
    _workouts.add(newWorkout);
    notifyListeners();
  }
}
