import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';

class WorkoutList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutsData = Provider.of<Workouts>(context);
    final workouts = workoutsData.workouts;
    print(workoutsData);
    return ListView.builder(
      shrinkWrap: true,
      // scrollDirection: Axis.horizontal,
      itemCount: workouts.length,
      itemBuilder: (context, i) {
        // return Text(workouts[i].name);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  WorkoutScreen.routeName,
                  arguments: workouts[i],
                );
              },
              child: ListTile(
                leading: SvgPicture.asset('assets/images/dumbbell.svg'),
                title: Text(
                  workouts[i].name,
                  style: TextStyle(
                      fontSize: 22,
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  '${workouts[i].workoutLength} min',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(0, 0, 0, 0.7)),
                ),
              ),
            ),
            Divider(
              thickness: 0,
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
