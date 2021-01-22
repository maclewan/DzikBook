import 'package:dzikbook/providers/notifications.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/screens/calendar_plans_screen.dart';
import 'package:dzikbook/screens/diet_list_screen.dart';
import 'package:dzikbook/screens/friends_list_screen.dart';
import 'package:dzikbook/screens/invitations_screen.dart';
import 'package:dzikbook/screens/notifications_screen.dart';
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
        // if (routeName != UserProfileScreen.routeName)
        InkWell(
          onTap: () => Navigator.of(context)
              .pushReplacementNamed(NotificationsScreen.routeName),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: null),
              if (Provider.of<Notifications>(context).unreadNotifications > 0)
                Positioned(
                  right: 5,
                  bottom: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red[500],
                    ),
                    width: 16.0,
                    height: 16.0,
                    child: Center(
                      child: Text(
                        Provider.of<Notifications>(context)
                            .unreadNotifications
                            .toString(),
                        style: TextStyle().copyWith(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
        // if (routeName != PersonsListScreen.routeName)
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                  PersonsListScreen.routeName,
                  arguments: false);
            }),
      ]);
}
