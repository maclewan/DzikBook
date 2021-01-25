import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'package:dzikbook/models/config.dart';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationClass {
  final String title;
  final String body;
  final String type;

  NotificationClass({
    @required this.title,
    @required this.body,
    @required this.type,
  });
}

class Notifications with ChangeNotifier {
  Dio dio = new Dio();
  String token;
  int _unreadNotifications = 0;
  List<NotificationClass> _notifications = [];

  List<NotificationClass> get notifications {
    return _notifications.reversed.toList();
  }

  int get unreadNotifications {
    return _unreadNotifications;
  }

  void incUnreadNotify() {
    _unreadNotifications += 1;
    notifyListeners();
  }

  void readNotify() {
    _unreadNotifications = 0;
    notifyListeners();
  }

  Future<void> fetchNotifications() async {
    final url = '$apiUrl/notifications/';
    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
          },
        ),
      );

      final List result = response.data;
      List<NotificationClass> _fetchedNotifications = [];
      for (var r in result) {
        _fetchedNotifications.add(
          NotificationClass(
            type: r['notification_type'],
            title: r['title'],
            body: r['body'],
          ),
        );
      }
      print(_fetchedNotifications);
      _notifications = _fetchedNotifications;
      notifyListeners();
    } catch (error) {
      throw HttpException('Wystąpił błąd.');
    }
  }

  Future<void> registerDevice(String deviceToken) async {
    final url = '$apiUrl/notifications/register_device/';
    Map<String, dynamic> body = {
      'token': deviceToken,
    };
    FormData formData = new FormData.fromMap(body);
    try {
      await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
          },
        ),
        data: formData,
      );
    } catch (error) {
      throw HttpException('Wystąpił błąd.');
    }
  }
}
