import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'package:dzikbook/models/config.dart';

import 'package:flutter/widgets.dart';

class Notifications with ChangeNotifier {
  Dio dio = new Dio();
  String token;

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
      print(error);
      throw HttpException('Twoja sesja wygasła. Zaloguj się ponownie');
    }
  }
}
