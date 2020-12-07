import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';

class WorkoutItem extends StatelessWidget {
  final Workout workout;

  WorkoutItem({this.workout});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workout.exercises.length,
      itemBuilder: (context, i) {
        return ExpansionTile(
          title: Text(
            workout.exercises[i].name,
          ),
          // children: ,
        );
      },
    );
  }
}
