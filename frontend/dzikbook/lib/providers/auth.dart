import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/HttpException.dart';

class Auth with ChangeNotifier {
  String _token;
  // String _userId;
  String _refreshToken;
  Timer _authTimer;
  DateTime _expiryDate;

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
    final url = "localhost:8000/auth/$urlSegment";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'username': email,
            'password': password,
            'first_name': firstName,
            'lastName': lastName,
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException("Operacja nie powiodłą się!");
      }
      final responseData = json.decode(response.body);

      _token = responseData['accessToken'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
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
    } catch (error) {
      throw error;
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

    if (expiryDate.isAfter(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _refreshToken = userData['refreshToken'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoTokenRefresh();
    return true;
  }

  Future<void> refreshToken() async {
    final url = 'localhost:8000/auth/login/refresh/';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'refresh': _refreshToken},
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Twoja sesja wygasła. Zaloguj się ponownie');
      }

      final responseData = json.decode(response.body);
      _token = responseData['accessToken'];
      _refreshToken = responseData['refreshToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
    } catch (error) {
      throw HttpException('Twoja sesja wygasła. Zaloguj się ponownie');
    }
    _autoTokenRefresh();
    notifyListeners();

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

// auth/login/

// localhost:8000/auth/login/refresh/
// body: {refresh: refreshToken}
// 201 200
