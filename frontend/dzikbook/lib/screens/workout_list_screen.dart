import 'package:dzikbook/screens/add_workout_screen.dart';
import 'package:dzikbook/widgets/drawer.dart';
import 'package:dzikbook/widgets/navbar.dart';
import 'package:flutter/material.dart';

import '../widgets/workout_list.dart';

class WorkoutListScreen extends StatelessWidget {
  static final routeName = '/workoutsList';

  @override
  Widget build(BuildContext context) {
    final addToPlan = ModalRoute.of(context).settings.arguments as bool;

    return Scaffold(
        drawer: Drawer(
          child: DrawerBody(),
        ),
        appBar: buildNavBar(
            context: context,
            routeName: WorkoutListScreen.routeName,
            title: 'Treningi'),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Flexible(
                  child: ListTile(
                leading: Text(
                  "Treningi",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 30),
                  textAlign: TextAlign.start,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AddWorkoutScreen.routeName);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                    size: 25,
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
