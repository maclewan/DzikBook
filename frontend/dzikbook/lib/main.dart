import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:dzikbook/widgets/workout_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/workouts.dart';

import './screens/auth_screen.dart';
import './screens/profile_screen.dart';
import './screens/splash_screen.dart';

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
            },
          ),
        ));
  }
}
