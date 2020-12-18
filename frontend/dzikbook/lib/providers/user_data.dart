import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dzikbook/models/config.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'package:dzikbook/providers/auth.dart';
import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String _name;
  String _lastName;
  String _imageUrl;
  String _gym;
  String _birthDate;
  String _sex;
  String _job;
  String _additionalData;
  String token;
  String refreshToken;
  Dio dio = new Dio();

  String get name => _name;
  String get lastName => _lastName;
  String get imageUrl => _imageUrl;
  String get gym => _gym;
  String get additionalData => _additionalData;
  String get birthDate => _birthDate;
  String get sex => _sex;
  String get job => _job;

  void update(Auth auth) {
    token = auth.token;
    refreshToken = auth.getRefreshToken;
  }

  Future<void> getUserData() async {
    final url = "$apiUrl/users/data/";
    final imgUrl = "$apiUrl/media/profile/";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }

      final Map parsed = response.data;
      this._name = parsed["first_name"];
      this._lastName = parsed["last_name"];
      this._additionalData = parsed["additionalData"];
      this._birthDate = parsed["birth_date"];
      this._gym = parsed["gym"];
      this._sex = parsed["sex"];
      this._job = parsed["job"];

      final imageResponse = await dio.get(imgUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      _imageUrl = apiUrl + imageResponse.data["photo"]["photo"];
      notifyListeners();
      // final Map parsedImg = json.decode(imageResponse.data);
      // print(parsedImg);
    } catch (error) {
      throw HttpException("Nie ma fotki!");
    }
  }
}
