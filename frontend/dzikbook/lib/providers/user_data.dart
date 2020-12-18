import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dzikbook/models/config.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'package:dzikbook/providers/auth.dart';
import 'package:flutter/material.dart';

class _UserPostData {
  String name;
  String image;
  bool isFriend;
  _UserPostData(this.name, this.image, this.isFriend);
}

class UserData with ChangeNotifier {
  String _name;
  String _id;
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
  String get id => _id;

  void update(Auth auth) {
    token = auth.token;
    refreshToken = auth.getRefreshToken;
  }

  Future<bool> isUserFriend(String userId) async {
    final url = "$apiUrl/friends/$userId";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        print("error 404");
        return false;
      }
      print(response);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<String> getOtherUserName(String userId) async {
    final url = "$apiUrl/users/data/";
    final response = await dio.get(url,
        options: Options(headers: {
          "Authorization": "Bearer " + token,
        }));
    if (response.statusCode >= 400) {
      throw HttpException("Operacja nie powiodła się!");
    }
    final Map parsed = response.data;
    return parsed["first_name"] + " " + parsed["last_name"];
  }

  Future<String> getOtherUserImage(String userId) async {
    final imgUrl = "$apiUrl/media/profile/$userId/";

    final imageResponse = await dio.get(imgUrl,
        options: Options(headers: {
          "Authorization": "Bearer " + token,
        }));
    {
      return apiUrl + imageResponse.data["photo"]["photo"];
    }
  }

  Future<bool> getOtherUserFriendStatus(String userId) async {
    final friendUrl = "$apiUrl/friends/$userId/";
    final response = await dio.get(friendUrl,
        options: Options(headers: {
          "Authorization": "Bearer " + token,
        }));
    {
      return response.data == "friends";
    }
  }

  Future<bool> changeProfilePicture(File picture) async {
    final url = "$apiUrl/media/profile/";

    FormData formData = new FormData();
    formData.files.add(MapEntry(
      "photo",
      await MultipartFile.fromFile(picture.path, filename: picture.path),
    ));
    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer " + token,
          },
        ),
        data: formData,
      );
      print("IMAGE CHANGED");
      _imageUrl = apiUrl + response.data[0]["photo"]["photo"];
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<_UserPostData> getAnotherUserData(String userId) async {
    try {
      _UserPostData _userPostData;
      Future.wait([
        getOtherUserName(userId),
        getOtherUserImage(userId),
        getOtherUserFriendStatus(userId)
      ]).then((values) {
        print(values);
        _userPostData = _UserPostData(values[0], values[1], values[2]);
      });
      return _userPostData;
    } catch (error) {
      print(error);
      return null;
    }
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
      this._id = parsed["user"].toString();
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
