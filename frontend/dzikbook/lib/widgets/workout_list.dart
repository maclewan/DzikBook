import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/workouts.dart';

class WorkoutList extends StatelessWidget {
  final bool addToPlans;

  WorkoutList({this.addToPlans});

  @override
  Widget build(BuildContext context) {
    final workoutsData = Provider.of<Workouts>(context);
    final workouts = workoutsData.workouts;
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (context, i) {
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
                leading: SvgPicture.asset(
                  'assets/images/dumbbell.svg',
                  height: 30,
                ),
                title: Text(
                  workouts[i].name,
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 0, 0, 0.7),
                      fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${workouts[i].workoutLength} min',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.7)),
                    ),
                    Visibility(
                      visible: addToPlans,
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(workouts[i]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 0,
            ),
          ],
        );
      },
    );
  }
}
