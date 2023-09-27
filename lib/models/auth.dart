import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  static UserModel user = UserModel();

  Future<bool> isUserLoggedIn() async {
    await getUserAuth();
    if (user.userId != null) {
      return true;
    }
    return false;
  }

  Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userAuth') == true) {
      Map<String, dynamic> authUser = jsonDecode(prefs.getString('userAuth')!);
      return UserModel.fromJson(authUser).userName;
    }
    return null;
  }

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userAuth') == true) {
      Map<String, dynamic> authUser = jsonDecode(prefs.getString('userAuth')!);
      return UserModel.fromJson(authUser).userId;
    }
    return null;
  }

  Future<String?> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userAuth') == true) {
      Map<String, dynamic> authUser = jsonDecode(prefs.getString('userAuth')!);
      return UserModel.fromJson(authUser).role;
    }
    return null;
  }

  Future<void> saveUserAuth(UserModel userModel) async {
    user = userModel;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAuth', jsonEncode(userModel.toJson()));
  }

  static Future<void> getUserAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userAuth') == true) {
      Map<String, dynamic> authUser = jsonDecode(prefs.getString('userAuth')!);
      user = UserModel.fromJson(authUser);
    }
  }

  static Future<void> clearUserAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    user = UserModel();
    prefs.clear();
  }
}

class UserModel {
  String? userEmail;
  String? userId;
  String? userName;
  String? role;

  UserModel({this.userEmail, this.userId, this.userName, this.role});

  UserModel.fromJson(Map<String, dynamic> json) {
    userEmail = json["userEmail"];
    userId = json["userId"];
    userName = json["userName"];
    role = json["role"];
  }

  Map<String, String> toJson() {
    return {
      'userEmail': userEmail!,
      'userId': userId!,
      'userName': userName!,
      'role': role!
    };
  }
}
