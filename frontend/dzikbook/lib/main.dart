import 'package:firebase_messaging/firebase_messaging.dart';
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

import './services/push_notification_service.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
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
            home: ProfileScreen(),
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
            },
          ),
        ));
  }
}
