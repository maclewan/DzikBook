import 'package:dzikbook/screens/add_diet_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/workouts.dart';
import './providers/diets.dart';
import './providers/static.dart';

import './screens/auth_screen.dart';
import './screens/profile_screen.dart';
import './screens/splash_screen.dart';
import './screens/workout_list_screen.dart';
import './screens/workout_screen.dart';
import './screens/diet_screen.dart';
import './screens/diet_list_screen.dart';
import 'screens/add_workout_screen.dart';
import 'screens/search_people_screen.dart';

void main() {
  runApp(MyApp());
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
            home: PersonsListScreen(),
            routes: {
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
              WorkoutScreen.routeName: (ctx) => WorkoutScreen(),
              DietListScreen.routeName: (ctx) => DietListScreen(),
              DietScreen.routeName: (ctx) => DietScreen(),
              AddWorkoutScreen.routeName: (ctx) => AddWorkoutScreen(),
              AddDietScreen.routeName: (ctx) => AddDietScreen(),
              PersonsListScreen.routeName: (ctx) => PersonsListScreen(),
            },
          ),
        ));
  }
}
