import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import './user_model.dart';

class AuthUtility {
  AuthUtility._();

  static AuthUserModel userModel = AuthUserModel();

  static Future<void> saveUserInfo(AuthUserModel authUserModel) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        'user-auth', jsonEncode(authUserModel.toJson()));
    userModel = authUserModel;
  }

  static Future<void> updateUserInfo(UserData userData) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userModel.data = userData;
    await sharedPrefs.setString('user-auth', jsonEncode(userModel.toJson()));
  }

  static Future<AuthUserModel> getUserInfo() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String userAuthData = sharedPrefs.getString('user-auth')!;
    return AuthUserModel.fromJson(jsonDecode(userAuthData));
  }

  static Future<bool> isUserLoggedIn() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPrefs.containsKey('user-auth');
    if (isLoggedIn == true) {
      userModel = await getUserInfo();
    }
    return isLoggedIn;
  }

  static Future<void> clearUserInfo() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.remove('user-auth');
  }
}
