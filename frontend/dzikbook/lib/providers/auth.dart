import 'dart:convert';
import 'dart:async';
// import 'package:universal_html/html.dart';
import 'package:dio/dio.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:universal_html/prefer_universal/html.dart';

import '../models/HttpException.dart';

class Auth with ChangeNotifier {
  String _token;
  // String _userId;
  String _refreshToken;
  Timer _authTimer;
  DateTime _expiryDate;
  Dio dio = new Dio();

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return '';
  }

  Future<void> _authentication(String password, String email, String urlSegment,
      String firstName, String lastName) async {
    final url = "http://10.0.2.2:8000/auth/$urlSegment/";

    Map<String, dynamic> body = {
      'email': email,
      'username': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };
    FormData formData = new FormData.fromMap(body);
    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
        data: formData,
      );
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodła się!");
      }
      if (urlSegment == 'login') {
        final responseData = response.data;
        _token = responseData['access'];
        _refreshToken = responseData['refresh'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: 3600,
          ),
        );
        _autoTokenRefresh();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'refreshToken': _refreshToken,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        prefs.setString('userData', userData);
      }
    } catch (error) {
      throw HttpException("Operacja nie powiodła się!");
    }
  }

  Future<void> signin(String email, String password) async {
    return _authentication(password, email, "login", '', '');
  }

  Future<void> signup(
      String email, String password, String lastName, String firstName) async {
    return _authentication(password, email, "register", firstName, lastName);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData = json.decode(
      prefs.getString('userData'),
    ) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['access'];
    _refreshToken = userData['refresh'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoTokenRefresh();
    return true;
  }

  Future<void> refreshToken() async {
    final url = 'http://10.0.2.2:8000/auth/login/refresh/';
    Map<String, dynamic> body = {
      'refresh': _refreshToken,
    };
    FormData formData = new FormData.fromMap(body);
    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
        data: formData,
      );

      final responseData = response.data;
      _token = responseData['access'];
      _refreshToken = responseData['refresh'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: 3600,
        ),
      );
      _autoTokenRefresh();
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Twoja sesja wygasła. Zaloguj się ponownie');
    }
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'refreshToken': _refreshToken,
      'expiryDate': _expiryDate.toIso8601String(),
    });
    prefs.setString('userData', userData);
  }

  Future<void> logout() async {
    _token = null;
    _refreshToken = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoTokenRefresh() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), refreshToken);
  }
}

// status code unathorized = 401
// unauthorized ? response.isKey(code) and response[code] = 'token_not_valid'
