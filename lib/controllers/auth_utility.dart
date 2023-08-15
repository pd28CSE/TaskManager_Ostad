import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user_model.dart';

class AuthUtility extends GetxController {
  static AuthUserModel userModel = AuthUserModel();

  static Future<void> saveUserInfo(AuthUserModel authUserModel) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString(
        'user-auth', jsonEncode(authUserModel.toJson()));
    userModel = authUserModel;
  }

  Future<void> updateUserInfo(UserData userData) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    userModel.data = userData;
    await sharedPrefs.setString('user-auth', jsonEncode(userModel.toJson()));
    update();
  }

  Future<AuthUserModel> getUserInfo() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String userAuthData = sharedPrefs.getString('user-auth')!;
    return AuthUserModel.fromJson(jsonDecode(userAuthData));
  }

  Future<bool> isUserLoggedIn() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPrefs.containsKey('user-auth');
    if (isLoggedIn == true) {
      userModel = await getUserInfo();
      update();
    }
    return isLoggedIn;
  }

  static Future<void> clearUserInfo() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.remove('user-auth');
  }
}
