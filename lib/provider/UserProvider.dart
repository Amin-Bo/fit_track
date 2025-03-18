import 'package:flutter/material.dart';
import '../model/User.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    email: '',
    firstName: '',
    lastName: '',
    height: 0.0,
    weight: 0.0,
    profilePicture: '',
  );

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {}
}
