import 'package:dzikbook/providers/workouts.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPost extends StatelessWidget {
  final Workout workout;
  const WorkoutPost({Key key, @required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      margin: EdgeInsets.symmetric(vertical: 10),
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
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        this.workout.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
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
                    onPressed: () {
                      Provider.of<Workouts>(context, listen: false)
                          .addWorkout(workout);
                    },
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text("Zapisz",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
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
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text("Zobacz",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
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
