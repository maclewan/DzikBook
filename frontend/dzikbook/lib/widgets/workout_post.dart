import 'package:dzikbook/providers/workouts.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:flutter/material.dart';

class WorkoutPost extends StatelessWidget {
  final Workout workout;
  const WorkoutPost({Key key, @required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      color: Colors.green[400],
                      size: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      this.workout.name,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                Text('${this.workout.workoutLength}m',
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlineButton(
                    onPressed: () {},
                    child: Text("Zapisz",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w400)),
                    borderSide: BorderSide(color: Colors.green, width: 1.2),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Expanded(
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(WorkoutScreen.routeName,
                          arguments: this.workout);
                    },
                    child: Text("Zobacz",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w400,
                        )),
                    borderSide: BorderSide(color: Colors.green, width: 1.2),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
