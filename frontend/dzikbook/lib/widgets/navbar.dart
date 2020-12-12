import 'package:dzikbook/screens/diet_list_screen.dart';
import 'package:dzikbook/screens/profile_screen.dart';
import 'package:dzikbook/screens/search_people_screen.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:flutter/material.dart';

AppBar buildNavBar(
    {BuildContext context,
    String title,
    String routeName,
    List<Widget> children}) {
  return AppBar(title: new Text(title), actions: [
    IconButton(
        icon: Icon(Icons.home),
        onPressed: () {
          if (routeName != ProfileScreen.routeName) {
            Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName,
                arguments: false);
          }
        }),
    IconButton(
        icon: Icon(Icons.person),
        onPressed: () {
          if (routeName != UserProfileScreen.routeName) {
            Navigator.of(context).pushReplacementNamed(
                UserProfileScreen.routeName,
                arguments: false);
          }
        }),
    IconButton(
        icon: Icon(Icons.food_bank),
        onPressed: () {
          if (routeName != DietListScreen.routeName) {
            Navigator.of(context).pushReplacementNamed(DietListScreen.routeName,
                arguments: false);
          }
        }),
    IconButton(
        icon: Icon(Icons.fitness_center),
        onPressed: () {
          if (routeName != WorkoutListScreen.routeName) {
            Navigator.of(context).pushReplacementNamed(
                WorkoutListScreen.routeName,
                arguments: false);
          }
        }),
    if (routeName != PersonsListScreen.routeName)
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
                PersonsListScreen.routeName,
                arguments: false);
          }),
    if (children != null) ...children
  ]);
}
