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
                fontSize: 36,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
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
// Flexible(
//                   // width: 100,
//                   child: ListTile(
//                 leading: Text(
//                   "Treningi",
//                   style: TextStyle(
//                       fontFamily: 'Montserrat',
//                       fontWeight: FontWeight.w700,
//                       fontSize: 36),
//                   textAlign: TextAlign.start,
//                 ),
//                 trailing: IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pushNamed(AddWorkoutScreen.routeName);
//                   },
//                   icon: Icon(
//                     Icons.add,
//                     color: Theme.of(context).primaryColor,
//                     size: 35,
//                   ),
//                 ),
//               )),
