import 'package:flutter/cupertino.dart';
import 'package:shop/User/User.dart';

class UserData extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void login(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}