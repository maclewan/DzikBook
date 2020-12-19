import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/screens/calendar_plans_screen.dart';
import 'package:dzikbook/screens/diet_list_screen.dart';
import 'package:dzikbook/screens/friends_list_screen.dart';
import 'package:dzikbook/screens/invitations_screen.dart';
import 'package:dzikbook/screens/profile_screen.dart';
import 'package:dzikbook/screens/search_people_screen.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppBar buildNavBar(
    {BuildContext context,
    String title,
    String routeName,
    List<Widget> children}) {
  return AppBar(
      title: title.length == 0
          ? null
          : FittedBox(fit: BoxFit.contain, child: Text(title)),
      actions: [
        if (routeName != ProfileScreen.routeName)
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    ProfileScreen.routeName,
                    arguments: false);
              }),
        if (routeName != UserProfileScreen.routeName)
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                final userDataProvider =
                    Provider.of<UserData>(context, listen: false);
                userDataProvider
                    .getUserPostsCount(userDataProvider.id)
                    .then((List<int> posts) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(
                        postsCount: posts[0],
                        trainingsCount: posts[1],
                        dietsCount: posts[2],
                        id: userDataProvider.id,
                        friend: false,
                        rootUser: true,
                        userName: userDataProvider.name +
                            " " +
                            userDataProvider.lastName,
                        userImage: userDataProvider.imageUrl,
                      ),
                    ),
                  );
                });
              }),
        if (routeName != DietListScreen.routeName)
          IconButton(
              icon: Icon(Icons.food_bank),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    DietListScreen.routeName,
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
        if (routeName != FriendsListScreen.routeName)
          IconButton(
              icon: Icon(Icons.group),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    FriendsListScreen.routeName,
                    arguments: false);
              }),
        if (routeName != InvitationsScreen.routeName)
          IconButton(
              icon: Icon(Icons.group_add),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    InvitationsScreen.routeName,
                    arguments: false);
              }),
      ]);
}
