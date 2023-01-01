import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../utils/api_key.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth => token != '';

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return '';
  }

  String get userId => _userId ?? '';

  Future<void> _authenticate(
      String email, String password, String urlPath) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlPath?key=$API_KEY';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'] ?? '';
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
      // print(_token);
      // print(_userId);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  } 

  void _autoLogout() {
    if (_authTimer != null) _authTimer!.cancel();

    final timeToExpiry = _expiryDate != null
        ? _expiryDate!.difference(DateTime.now()).inSeconds
        : 0;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () => logout());
  }
}
