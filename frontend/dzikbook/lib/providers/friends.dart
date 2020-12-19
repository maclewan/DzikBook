import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dzikbook/models/config.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'package:flutter/material.dart';

class _Friend {
  final String userName;
  final String userId;
  final String userImg;
  _Friend({this.userName, this.userId, this.userImg});
}

class Friends with ChangeNotifier {
  String token;
  final Dio dio = new Dio();
  List<_Friend> _friends = [];
  List<_Friend> get friends => _friends;
  bool _hasFetched = false;
  bool get hasFetched => _hasFetched;

  Future<String> getOtherUserImage(String userId) async {
    final imgUrl = "$apiUrl/media/profile/user/$userId/";
    try {
      final imageResponse = await dio.get(imgUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      return apiUrl + imageResponse.data["photo"]["photo"];
    } catch (error) {
      print(error);
      print("WYWALA USERIMG");
      return defaultPhotoUrl;
    }
  }

  Future<bool> deleteUserFromFriends(String userId) async {
    final url = "$apiUrl/friends/$userId/";
    try {
      final response = await dio.delete(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      print(response);
      _friends.removeWhere((friend) => friend.userId == userId);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      print("Nie wywalono ze znajomych");
      return false;
    }
  }

  Future<void> fetchFriendsList() async {
    final url = "$apiUrl/friends/list";
    print("zaczynam fetchować friends");
    print(token);
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      print(response);
      final List parsed = response.data["user_data_list"];
      await Future.wait([
        for (final id in parsed)
          getOtherUserImage(id["user_id"].toString()).then((response) {
            print(response);
            _friends.add(new _Friend(
                userId: id["user_id"].toString(),
                userImg: response,
                userName: id["first_name"] + " " + id["last_name"]));
          })
      ]);
      _hasFetched = true;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
