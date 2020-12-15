import 'package:dzikbook/screens/calendar_plans_screen.dart';
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
    if (routeName != ProfileScreen.routeName)
      IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName,
                arguments: false);
          }),
    if (routeName != UserProfileScreen.routeName)
      IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
                UserProfileScreen.routeName,
                arguments: false);
          }),
    if (routeName != DietListScreen.routeName)
      IconButton(
          icon: Icon(Icons.food_bank),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(DietListScreen.routeName,
                arguments: false);
          }),
    if (routeName != WorkoutListScreen.routeName)
      IconButton(
          icon: Icon(Icons.fitness_center),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
                WorkoutListScreen.routeName,
                arguments: false);
          }),
    if (routeName != PersonsListScreen.routeName)
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
                PersonsListScreen.routeName,
                arguments: false);
          }),
    if (routeName != CalendarPlansScreen.routeName)
      IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
                CalendarPlansScreen.routeName,
                arguments: false);
          }),
  ]);
}
