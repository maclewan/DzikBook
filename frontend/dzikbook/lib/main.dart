import 'package:dzikbook/providers/friends.dart';
import 'package:dzikbook/providers/posts.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/screens/friends_list_screen.dart';
import 'package:dzikbook/screens/user_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import './providers/auth.dart';
import './providers/workouts.dart';
import './providers/diets.dart';
import './providers/static.dart';
import './providers/dayPlans.dart';

import './screens/auth_screen.dart';
import './screens/profile_screen.dart';
import './screens/splash_screen.dart';
import './screens/workout_list_screen.dart';
import './screens/workout_screen.dart';
import './screens/diet_screen.dart';
import './screens/diet_list_screen.dart';
import './screens/add_workout_screen.dart';
import './screens/add_diet_screen.dart';
import './screens/calendar_plans_screen.dart';
import 'screens/add_workout_screen.dart';
import 'screens/search_people_screen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => Workouts(),
          ),
          ChangeNotifierProvider(
            create: (context) => Diets(),
          ),
          ChangeNotifierProvider(
            create: (context) => Static(),
          ),
          ChangeNotifierProvider(
            create: (context) => DayPlans(),
          ),
          ChangeNotifierProxyProvider<Auth, UserData>(
            create: (_) => UserData(),
            update: (_, auth, userData) => userData..update(auth),
          ),
          ChangeNotifierProxyProvider<UserData, Posts>(
              create: (_) => Posts(),
              update: (_, userData, posts) => posts
                ..token = userData.token
                ..refreshToken = userData.refreshToken
                ..userId = userData.id),
          ChangeNotifierProxyProvider<Auth, Friends>(
            create: (_) => Friends(),
            update: (_, auth, friends) => friends..token = auth.token,
          )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.green,
              accentColor: Colors.green,
              fontFamily: 'Montserrat',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
            routes: {
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
              WorkoutScreen.routeName: (ctx) => WorkoutScreen(),
              DietListScreen.routeName: (ctx) => DietListScreen(),
              DietScreen.routeName: (ctx) => DietScreen(),
              AddWorkoutScreen.routeName: (ctx) => AddWorkoutScreen(),
              AddDietScreen.routeName: (ctx) => AddDietScreen(),
              CalendarPlansScreen.routeName: (ctx) => CalendarPlansScreen(),
              PersonsListScreen.routeName: (ctx) => PersonsListScreen(),
              UserSettingsScreeen.routeName: (ctx) => UserSettingsScreeen(),
              FriendsListScreen.routeName: (ctx) => FriendsListScreen(),
            },
          ),
        ));
  }
}
