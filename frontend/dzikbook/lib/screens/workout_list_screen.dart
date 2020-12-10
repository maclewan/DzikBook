import 'package:dzikbook/screens/add_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';
import '../widgets/workout_list.dart';

class WorkoutListScreen extends StatelessWidget {
  static final routeName = '/workoutsList';

  @override
  Widget build(BuildContext context) {
    // final workoutsData = Provider.of<Workouts>(context);
    // final workouts = workoutsData.workouts;
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(AddWorkoutScreen.routeName);
        //   },
        // ),
        body: Container(
      // padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
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
            child: WorkoutList(),
          ),
        ],
      ),
      // child: WorkoutList(),
    ));
  }
}
