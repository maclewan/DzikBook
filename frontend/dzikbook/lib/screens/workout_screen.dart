import 'package:flutter/material.dart';
import '../widgets/exercise_item.dart';

import '../providers/workouts.dart';

class WorkoutScreen extends StatelessWidget {
  static final routeName = '/workout';

  @override
  Widget build(BuildContext context) {
    final workoutData = ModalRoute.of(context).settings.arguments as Workout;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(workoutData.name),
      ),
      body: Container(
        width: deviceSize.width,
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: workoutData.exercises.length,
                itemBuilder: (context, id) => ExerciseItem(
                  exerciseData: workoutData.exercises[id],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
