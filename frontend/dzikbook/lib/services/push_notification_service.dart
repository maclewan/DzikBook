import 'dart:convert';
import 'dart:io';

import 'package:dzikbook/providers/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm;

  PushNotificationService(this._fcm);

  Future initialise(BuildContext context) async {
    if (Platform.isMacOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('deviceTok', token);
    print('stworzyłem XDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
    if (prefs.containsKey('deviceTok')) {
      print(
          'mam goooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    }
    final notifications = Provider.of<Notifications>(context, listen: false);
    notifications.registerDevice(token);
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        notifications.incUnreadNotify();
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}
