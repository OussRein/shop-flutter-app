import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _experationDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_experationDate != null &&
        _token != null &&
        _experationDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String segment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=AIzaSyBAucpXxVIpuPOziNbwNI-JDEKGqP5o7jM');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final authData = json.decode(response.body);
      if (authData['error'] != null) {
        throw HttpException(authData['error']['message']);
      }
      print (authData['idToken']);
      _token = authData['idToken'];
            

      _userId = authData['localId'];
      _experationDate = DateTime.now()
          .add(Duration(seconds: int.parse(authData['expiresIn'])));
      print (_experationDate);
      notifyListeners();
    } catch (error) {
      print (error);
      return error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
