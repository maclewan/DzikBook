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

class _Invitation {
  final String userId;
  final String userName;
  final String userImg;
  final String invitationId;
  _Invitation({this.userName, this.userImg, this.userId, this.invitationId});
}

class Friends with ChangeNotifier {
  String token;
  final Dio dio = new Dio();
  List<_Friend> _friends = [];
  List<_Invitation> _invitations = [];
  List<_Friend> get friends => _friends;
  List<_Invitation> get invitations => _invitations;
  bool _hasFetched = false;
  bool _hasFetchedInvitations = false;
  bool get hasFetched => _hasFetched;
  bool get hasFetchedInvitations => _hasFetchedInvitations;

  void clearFriendList() {
    _friends.clear();
    _hasFetched = false;
  }

  void clearInvitations() {
    _invitations.clear();
    _hasFetchedInvitations = false;
  }

  Future<String> getOtherUserName(String userId) async {
    final url = "$apiUrl/users/basic/$userId/";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      final Map parsed = response.data;
      return parsed["first_name"] + " " + parsed["last_name"];
    } catch (error) {
      print(error);
      return "";
    }
  }

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

  Future<bool> denyFriendRequest(String invitationId) async {
    final imgUrl = "$apiUrl/friends/request/manage/$invitationId/";
    try {
      final response = await dio.delete(imgUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      print(response);
      _invitations.removeWhere((inv) => inv.invitationId == invitationId);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      print("nie odrzucono");
      return false;
    }
  }

  Future<bool> acceptFriendRequest(String invitationId) async {
    final imgUrl = "$apiUrl/friends/request/manage/$invitationId/";
    try {
      final response = await dio.post(imgUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      _invitations.removeWhere((inv) => inv.invitationId == invitationId);
      _hasFetched = false;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      print("nie zaakceptowano");
      return false;
    }
  }

  Future<bool> deleteUserFromFriends(String userId) async {
    final url = "$apiUrl/friends/$userId/";
    try {
      await dio.delete(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      _friends.removeWhere((friend) => friend.userId == userId);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      print("Nie wywalono ze znajomych");
      return false;
    }
  }

  Future<bool> getFriendInvitations() async {
    final url = "$apiUrl/friends/request/";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      final List parsed = response.data["invitations_list"];
      await Future.wait([
        for (final inv in parsed)
          Future.wait([
            getOtherUserImage(inv["sender"].toString()),
            getOtherUserName(inv["sender"].toString()),
          ]).then((responses) {
            _invitations.add(new _Invitation(
              invitationId: inv["id"].toString(),
              userId: inv["sender"].toString(),
              userImg: responses[0],
              userName: responses[1],
            ));
          }),
      ]);
      _hasFetchedInvitations = true;
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> fetchFriendsList() async {
    final url = "$apiUrl/friends/list";
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      final List parsed = response.data["user_data_list"];
      await Future.wait([
        for (final id in parsed)
          getOtherUserImage(id["user_id"].toString()).then((response) {
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
