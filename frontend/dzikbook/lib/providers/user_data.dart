import 'package:dio/dio.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'package:dzikbook/providers/auth.dart';
import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String _name;
  String _lastName;
  String _imageUrl;
  String token;
  String refreshToken;
  Dio dio = new Dio();

  void update(Auth auth) {
    token = auth.token;
    refreshToken = auth.getRefreshToken;
  }

  Future<void> getUserData() async {
    print(token);
    final url = "http://10.0.3.2:8000/users/data/4";

    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": 'key=$token',
            "Content-Type": "application/json; charset=utf-8",
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      print(response.data);
      // notifyListeners();
    } catch (error) {
      throw HttpException("Operacja nie powiodła się!");
    }
  }
}
