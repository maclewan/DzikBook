import 'package:dio/dio.dart';
import 'package:dzikbook/models/config.dart';
import 'package:flutter/material.dart';

class _User {
  final String userName;
  final String userId;
  final String userImg;
  _User({this.userName, this.userId, this.userImg});
}

class SearchPeople with ChangeNotifier {
  String token;
  final Dio dio = new Dio();
  List<_User> _users = [];
  List<_User> get users => _users;

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

  Future<bool> sendFriendRequest(String userId) async {
    final url = "$apiUrl/friends/request/$userId/";
    final data = {
      'user_id': userId,
    };
    final FormData formData = FormData.fromMap(data);
    try {
      final response = await dio.post(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }),
          data: formData);

      print(response);
      _users.removeWhere((user) => user.userId == userId);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      print("Nie zaproszono znajomego");
      return false;
    }
  }

  Future<void> searchPeopleList(String key) async {
    _users.clear();
    final url = "$apiUrl/users/search?key=name&value=$key&amount=100&offset=0";
    print("zaczynam szukać przyjaciół!");
    try {
      final response = await dio.get(url,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
      if (response.statusCode >= 400) {
        print("BŁĄD ${response.statusCode} - ${response.statusMessage}");
        return;
      }
      print(response);
      final List parsed = response.data["users_list"];
      await Future.wait([
        for (final id in parsed)
          getOtherUserImage(id["user_id"].toString()).then((response) {
            _users.add(new _User(
                userId: id["user_id"].toString(),
                userImg: response,
                userName: id["first_name"] + " " + id["last_name"]));
          })
      ]);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
