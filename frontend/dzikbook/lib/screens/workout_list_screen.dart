import 'package:dzikbook/screens/add_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../widgets/workout_list.dart';

class WorkoutListScreen extends StatelessWidget {
  static final routeName = '/workoutsList';

  @override
  Widget build(BuildContext context) {
    final addToPlan = ModalRoute.of(context).settings.arguments as bool;

    return Scaffold(
        body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          Flexible(
              child: ListTile(
            leading: Text(
              "Treningi",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 36),
              textAlign: TextAlign.start,
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddWorkoutScreen.routeName);
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
                size: 35,
              ),
            ),
          )),
          Flexible(
            flex: 10,
            child: WorkoutList(
              addToPlans: addToPlan,
            ),
          ),
        ],
      ),
      // child: WorkoutList(),
    ));
  }
}
