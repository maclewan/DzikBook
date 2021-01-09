import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dzikbook/models/config.dart';
import 'package:dzikbook/models/HttpException.dart';
import 'package:dzikbook/providers/auth.dart';
import 'package:dzikbook/providers/diets.dart';
import 'package:dzikbook/providers/workouts.dart';
import 'package:flutter/material.dart';

class _UserPostData {
  List<int> posts;
  String name;
  String image;
  bool isFriend;
  _UserPostData(this.name, this.image, this.isFriend, this.posts);
}

class UserData with ChangeNotifier {
  String _name = '';
  String _id = '';
  String _lastName = '';
  String _imageUrl = defaultPhotoUrl;
  String _gym = '';
  String _birthDate = '01/01/1990';
  String _sex = '';
  String _job = '';
  Map<String, dynamic> _additionalData = {
    'diets': <Diet>[],
    'workouts': <Workout>[],
  };
  String token = '';
  String refreshToken = '';
  Dio dio = new Dio();

  String get name => _name;
  String get lastName => _lastName;
  String get imageUrl => _imageUrl;
  String get gym => _gym;
  Map<String, dynamic> get additionalData => _additionalData;
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
        print("error ${response.statusCode}: ${response.statusMessage}");
        return false;
      }
      print(response);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<List<int>> getUserPostsCount(String userId) async {
    List<String> urls = new List(3);
    List<int> postsCounts = [];
    if (userId == _id) {
      urls[0] = "$apiUrl/wall?amount=100000";
      urls[1] = "$apiUrl/wall?amount=100000&type=training";
      urls[2] = "$apiUrl/wall?amount=100000&type=diets";
    } else {
      urls[0] = "$apiUrl/wall/$userId?amount=100000";
      urls[1] = "$apiUrl/wall/$userId?amount=100000&type=training";
      urls[2] = "$apiUrl/wall/$userId?amount=100000&type=diets";
    }
    try {
      await Future.wait([
        for (int i = 0; i < 3; i++)
          dio.get(urls[i],
              options: Options(headers: {
                "Authorization": "Bearer " + token,
              })),
      ]).then((responses) {
        List p = responses[0].data;
        List pTraining = responses[1].data;
        List pDiets = responses[2].data;
        postsCounts.add(p.length);
        postsCounts.add(pTraining.length);
        postsCounts.add(pDiets.length);
      });
      return postsCounts;
    } catch (error) {
      print(error);
      return [0, 0, 0];
    }
  }

  Future<void> changeUserData(
      {String newGym,
      String newSex,
      String newBirthDate,
      String newJob}) async {
    final url = "$apiUrl/users/data/";
    final data = {
      'gym': newGym,
      'additional_data': json.encode(
        mapAdditionalData(),
      ),
      'first_name': this._name,
      'last_name': this._lastName,
      'sex': newSex,
      'job': newJob,
      'birth_date': newBirthDate,
    };
    FormData formData = FormData.fromMap(data);
    try {
      await dio
          .put(url,
              data: formData,
              options: Options(headers: {
                "Authorization": "Bearer " + token,
              }))
          .then((response) {
        if (response.statusCode >= 400) {
          print("BŁĄD ${response.statusCode} - ${response.statusMessage}");
        }
        final Map parsed = response.data["user_data"];

        this._birthDate = parsed["birth_date"];
        this._gym = parsed["gym"];
        this._sex = parsed["sex"];
        this._job = parsed["job"];
        notifyListeners();
      });

      // final Map parsedImg = json.decode(imageResponse.data);
      // print(parsedImg);
    } catch (error) {
      throw HttpException("Nie ma fotki!");
    }
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

  Future<bool> getOtherUserFriendStatus(String userId) async {
    final friendUrl = "$apiUrl/friends/$userId/";
    try {
      final response = await dio.get(friendUrl,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));

      return response.data["relation"] == "Friends";
    } catch (error) {
      print(error);
      return false;
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
      await Future.wait([
        getOtherUserName(userId),
        getOtherUserImage(userId),
        getOtherUserFriendStatus(userId),
        getUserPostsCount(userId),
      ]).then((values) {
        _userPostData =
            _UserPostData(values[0], values[1], values[2], values[3]);
      });
      return _userPostData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Map<String, List> mapFetchedAddData(data) {
    try {
      data = json.decode(data);
      Map<String, List> newData = {
        'workouts': data['workouts']
            .map<Workout>(
              (workout) => Workout(
                id: workout['id'],
                name: workout['name'],
                workoutLength: workout['length'],
                exercises: workout['exercises']
                    .map<Exercise>(
                      (e) => Exercise(
                        id: e['id'],
                        name: e['name'],
                        series: int.parse(e['series']),
                        reps: int.parse(
                          e['reps'],
                        ),
                        breakTime: int.parse(
                          e['breakTime'],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
        'diets': data['diets']
            .map<Diet>(
              (diet) => Diet(
                id: diet['id'],
                name: diet['name'],
                dietCalories: diet['calories'],
                foodList: diet['food']
                    .map<Food>(
                      (food) => Food(
                        id: food['id'],
                        name: food['name'],
                        weight: food['weight'],
                        protein: food['protein'],
                        calories: food['calories'],
                        carbs: food['carbs'],
                        fat: food['food'],
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      };
      return newData;
    } catch (error, stackTrace) {
      return {
        'diets': <Diet>[],
        'workouts': <Workout>[],
      };
    }
  }

  Future<void> getUserData() async {
    final url = "$apiUrl/users/data/";
    final imgUrl = "$apiUrl/media/profile/";
    try {
      Future.wait([
        dio.get(url,
            options: Options(headers: {
              "Authorization": "Bearer " + token,
            })),
        dio.get(imgUrl,
            options: Options(headers: {
              "Authorization": "Bearer " + token,
            }))
      ]).then((responses) {
        final response = responses[0];
        final imageResponse = responses[1];
        if (response.statusCode >= 400) {
          throw HttpException("Operacja nie powiodła się!");
        }
        final Map parsed = response.data;
        this._name = parsed["first_name"];
        this._lastName = parsed["last_name"];
        this._additionalData = mapFetchedAddData(parsed["additional_data"]);
        this._birthDate = parsed["birth_date"];
        this._gym = parsed["gym"];
        this._sex = parsed["sex"];
        this._job = parsed["job"];
        this._id = parsed["user"].toString();
        _imageUrl = apiUrl + imageResponse.data["photo"]["photo"];
        print(_imageUrl);
        notifyListeners();
      });

      // final Map parsedImg = json.decode(imageResponse.data);
      // print(parsedImg);
    } catch (error) {
      throw HttpException("Nie ma fotki!");
    }
  }

  Map<String, dynamic> mapAdditionalData() {
    Map<String, dynamic> newAddData = {
      'workouts': _additionalData['workouts']
          .map((Workout workout) => {
                'id': workout.id,
                'name': workout.name,
                'length': workout.workoutLength,
                'exercises': workout.exercises
                    .map((Exercise e) => {
                          'id': e.id,
                          'name': e.name,
                          'series': e.series.toString(),
                          'reps': e.reps.toString(),
                          'breakTime': e.breakTime.toString(),
                        })
                    .toList(),
              })
          .toList(),
      'diets': _additionalData['diets']
          .map((Diet diet) => {
                'id': diet.id,
                'name': diet.name,
                'calories': diet.dietCalories,
                'food': diet.foodList
                    .map((Food food) => {
                          'id': food.id,
                          'name': food.name,
                          'weight': food.weight,
                          'protein': food.protein,
                          'calories': food.calories,
                          'carbs': food.carbs,
                          'fat': food.fat,
                        })
                    .toList(),
              })
          .toList(),
    };
    return newAddData;
  }

  Future<void> updateAdditionalData() async {
    final url = "$apiUrl/users/data/";
    final data = {
      'gym': this._gym,
      'additional_data': json.encode(
        mapAdditionalData(),
      ),
      'first_name': this._name,
      'last_name': this._lastName,
      'sex': this._sex,
      'job': this._job,
      'birth_date': this._birthDate,
    };
    FormData formData = FormData.fromMap(data);
    try {
      await dio.put(url,
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer " + token,
          }));
    } catch (error) {
      throw HttpException(error);
    }
  }

  Future<void> updateWorkouts(List<Workout> workouts) async {
    Map<String, dynamic> oldAdditionalData = _additionalData;
    _additionalData['workouts'] = workouts;
    await updateAdditionalData().catchError((error) => {
          _additionalData = oldAdditionalData,
          throw HttpException(error),
        });
    notifyListeners();
  }

  Future<void> updateDiets(List<Diet> diets) async {
    Map<String, dynamic> oldAdditionalData = _additionalData;
    _additionalData['diets'] = diets;
    await updateAdditionalData().catchError((error) => {
          _additionalData = oldAdditionalData,
          throw HttpException(error),
        });
    notifyListeners();
  }
}
