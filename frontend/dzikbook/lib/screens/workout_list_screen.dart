import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../widgets/workout_list.dart';

class WorkoutListScreen extends StatelessWidget {
  static final routeName = '/workoutsList';

  @override
  Widget build(BuildContext context) {
    final workoutsData = Provider.of<Workouts>(context);
    final workouts = workoutsData.workouts;
    return Scaffold(
        body: Container(
      // padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment(-0.9, 0),
            child: Text(
              "Treningi",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 36),
              textAlign: TextAlign.start,
            ),
          ),
          Flexible(
            child: WorkoutList(),
          ),
        ],
      ),
      // child: WorkoutList(),
    ));
  }
}
