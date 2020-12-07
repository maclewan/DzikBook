import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: deviceSize.width,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              workoutData.name,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
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
