import 'package:dzikbook/providers/notifications.dart';
import 'package:dzikbook/screens/notifications_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import './providers/auth.dart';
import './providers/workouts.dart';
import './providers/diets.dart';
import './providers/static.dart';
import './providers/day_plans.dart';
import './providers/friends.dart';
import './providers/posts.dart';
import './providers/search_people.dart';
import './providers/user_data.dart';

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
import './screens/search_people_screen.dart';
import './screens/friends_list_screen.dart';
import './screens/invitations_screen.dart';
import './screens/user_settings_screen.dart';

import './services/push_notification_service.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final pushNotificationService = PushNotificationService(_firebaseMessaging);
    // pushNotificationService.initialise();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => Static(),
          ),
          ChangeNotifierProxyProvider<Auth, UserData>(
            create: (_) => UserData(),
            update: (_, auth, userData) => userData..update(auth),
          ),
          ChangeNotifierProxyProvider<UserData, DayPlans>(
            create: (context) => DayPlans(),
            update: (_, userData, dayPlans) => dayPlans
              ..token = userData.token
              ..userId = userData.id
              ..workouts = userData.additionalData['workouts']
              ..diets = userData.additionalData['diets'],
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
          ),
          ChangeNotifierProxyProvider<Auth, SearchPeople>(
            create: (_) => SearchPeople(),
            update: (_, auth, people) => people..token = auth.token,
          ),
          ChangeNotifierProxyProvider<UserData, Workouts>(
            create: (_) => Workouts(),
            update: (_, userData, workouts) => workouts
              ..update = userData.updateWorkouts
              ..workouts = userData.additionalData['workouts'],
          ),
          ChangeNotifierProxyProvider<UserData, Diets>(
            create: (_) => Diets(),
            update: (_, userData, workouts) => workouts
              ..update = userData.updateDiets
              ..diets = userData.additionalData['diets'],
          ),
          ChangeNotifierProxyProvider<Auth, Notifications>(
              create: (_) => Notifications(),
              update: (_, authData, notifications) =>
                  notifications..token = authData.token)
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
              InvitationsScreen.routeName: (ctx) => InvitationsScreen(),
              NotificationsScreen.routeName: (ctx) => NotificationsScreen(),
            },
          ),
        ));
  }
}
