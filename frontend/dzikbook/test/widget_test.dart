// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:dzikbook/screens/add_diet_screen.dart';
import 'package:dzikbook/screens/add_workout_screen.dart';
import 'package:dzikbook/screens/calendar_plans_screen.dart';
import 'package:dzikbook/screens/invitations_screen.dart';
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

void main() {
  testWidgets("Checking Auth Screen", (WidgetTester tester) async {
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
            home: AuthScreen(),
            routes: {
              WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
            },
          ),
        )));
    expect(find.text('Zarejestruj się'), findsOneWidget);
    expect(find.byType(GestureDetector), findsWidgets);
  });
  testWidgets("Checking userProfileScreen", (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
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
              home: UserProfileScreen(
                dietsCount: 10,
                id: "XD",
                postsCount: 15,
                trainingsCount: 10,
              ),
              routes: {
                WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
              },
            ),
          )));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(UserProfileInfo), findsOneWidget);
      expect(find.text('Posty'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('10'), findsNWidgets(2));
    });
  });

  testWidgets("Checking AddDiet", (WidgetTester tester) async {
    provideMockedNetworkImages(() async {
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
              home: AddDietScreen(),
              routes: {
                WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
              },
            ),
          )));
      await tester.tap(find.byIcon(Icons.done));
      await tester.pump();
      expect(find.text('Błąd!'), findsOneWidget);
      expect(find.byType(FlatButton), findsNWidgets(1));
      await tester.tap(find.byType(FlatButton));
      await tester.pump();
      expect(find.text('Błąd!'), findsNothing);
      expect(find.byType(FlatButton), findsNothing);
    });
  });

  testWidgets("Checking addWorkout", (WidgetTester tester) async {
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
            home: AddWorkoutScreen(),
            routes: {
              WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
            },
          ),
        )));
    expect(find.byType(Stack), findsNWidgets(2));
    expect(find.byType(ListTile), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('Wybierz ćwiczenie'), findsOneWidget);
    expect(find.text('Serie'), findsOneWidget);
    expect(find.text('Powtórzenia'), findsOneWidget);
    expect(find.text('Przerwa (sek)'), findsOneWidget);
    expect(find.text('Anuluj'), findsOneWidget);
    expect(find.byType(FlatButton), findsNWidgets(2));
    expect(find.text('Ćwiczenia'), findsOneWidget);
  });

  testWidgets("Checking InvitationsScreen", (WidgetTester tester) async {
    await provideMockedNetworkImages(() async {
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
              home: InvitationsScreen(),
              routes: {
                WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
              },
            ),
          )));
    });
    expect(find.byType(ListView), findsOneWidget);
  });
  testWidgets("Checking SocialIcon", (WidgetTester tester) async {
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
            home: SocialIcon(
              color: Colors.amber,
              deviceSize: Size(100, 100),
              icon: "assets/images/dzik.svg",
              press: null,
            ),
            routes: {
              WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
            },
          ),
        )));
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });
  testWidgets("Checking SocialIcon", (WidgetTester tester) async {
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
            home: SocialIcon(
              color: Colors.amber,
              deviceSize: Size(100, 100),
              icon: "assets/images/dzik.svg",
              press: null,
            ),
            routes: {
              WorkoutListScreen.routeName: (ctx) => WorkoutListScreen(),
            },
          ),
        )));
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });
}
