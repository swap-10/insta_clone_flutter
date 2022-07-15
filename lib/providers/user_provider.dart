import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/models/user.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserInfo? _userInfo;
  final AuthMethods _authMethods = AuthMethods();
  UserInfo get getUser => _userInfo!;

  Future<void> refreshUser() async {
    UserInfo userInfo = await _authMethods.getUserInfo();
    _userInfo = userInfo;
    notifyListeners();
  }
}
