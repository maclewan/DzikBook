import 'package:dzikbook/providers/workouts.dart';
import 'package:flutter/material.dart';

class WorkoutPost extends StatelessWidget {
  final Workout workout;
  const WorkoutPost({Key key, @required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(this.workout.name),
    );
  }
}
