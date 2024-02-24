import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  Map<String, dynamic>? userData;
  Map<String, dynamic>? get value => userData;
  String? playerEmail;

  setUserData(Map<String, dynamic> data) {
    userData = data;
    notifyListeners();
  }

  setUserEmail(String email) {
    playerEmail = email;
    notifyListeners();
  }

  String? get getEmail => playerEmail;

  removeUser() {
    userData = null;
    playerEmail = null;
    notifyListeners();
  }
}
