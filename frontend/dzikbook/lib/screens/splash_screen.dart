import 'dart:async';

import 'package:dzikbook/services/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import './auth_screen.dart';
import './profile_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<Auth>(context, listen: false);
    Timer(Duration(seconds: 3), () async {
      if (auth.isAuth) {
        _initFcm();
        Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
      } else {
        final autoLogin = await auth.tryAutoLogin().catchError((error) {
          print("Twoja sesja wygasła");
          return false;
        });
        if (autoLogin) {
          _initFcm();
          Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
        }
      }
    });
  }

  void _initFcm() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(33, 150, 83, 1),
            Color.fromRGBO(126, 213, 111, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
          child: SvgPicture.asset(
        'assets/images/dzikbook.svg',
        color: Colors.white,
      )),
    )));
  }
}
