import 'package:dzikbook/screens/calendar_plans_screen.dart';
import 'package:dzikbook/screens/diet_list_screen.dart';
import 'package:flutter/material.dart';

import './workout_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  static final routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(WorkoutListScreen.routeName);
            },
            child: Text(
              "Treningi",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(DietListScreen.routeName);
            },
            child: Text(
              "Diety",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(CalendarPlansScreen.routeName);
            },
            child: Text(
              "Kalendarz",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
