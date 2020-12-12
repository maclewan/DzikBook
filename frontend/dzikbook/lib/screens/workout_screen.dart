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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: deviceSize.width,
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Text(
              workoutData.name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15,
            ),
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
