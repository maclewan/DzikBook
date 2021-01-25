import 'package:dzikbook/screens/add_diet_screen.dart';
import 'package:dzikbook/screens/add_workout_screen.dart';
import 'package:dzikbook/screens/calendar_plans_screen.dart';
import 'package:dzikbook/screens/diet_list_screen.dart';
import 'package:dzikbook/screens/invitations_screen.dart';
import 'package:dzikbook/screens/user_settings_screen.dart';
import 'package:dzikbook/screens/workout_screen.dart';
import 'package:dzikbook/widgets/social_icon.dart';
import 'package:dzikbook/widgets/user_profile_info.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_test_utils/image_test_utils.dart';

import 'package:dzikbook/main.dart';
import 'package:dzikbook/providers/auth.dart';
import 'package:dzikbook/providers/day_plans.dart';
import 'package:dzikbook/providers/diets.dart';
import 'package:dzikbook/providers/friends.dart';
import 'package:dzikbook/providers/notifications.dart';
import 'package:dzikbook/providers/posts.dart';
import 'package:dzikbook/providers/search_people.dart';
import 'package:dzikbook/providers/static.dart';
import 'package:dzikbook/providers/user_data.dart';
import 'package:dzikbook/providers/workouts.dart';
import 'package:dzikbook/screens/auth_screen.dart';
import 'package:dzikbook/screens/profile_screen.dart';
import 'package:dzikbook/screens/splash_screen.dart';
import 'package:dzikbook/screens/user_profile_screen.dart';
import 'package:dzikbook/screens/workout_list_screen.dart';
import 'package:dzikbook/widgets/add_comment.dart';
import 'package:dzikbook/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/prefer_sdk/js.dart';

void main() {
  testWidgets("Test WorkoutListScreen", (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
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
            home: Navigator(
              onGenerateRoute: (_) {
                final bool arg = true;
                return MaterialPageRoute<Widget>(
                  builder: (_) => DietListScreen(),
                  settings: RouteSettings(arguments: arg),
                );
              },
            ),
            routes: {
              WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
            },
          ),
        )));
    expect(find.text('Diety'), findsWidgets);
    expect(find.byType(Container), findsWidgets);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pump();
  });
}
