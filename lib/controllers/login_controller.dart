import 'package:get/get.dart';

import 'auth_utility.dart';
import '../data/models/network_response.dart';
import '../data/models/user_model.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class LoginController extends GetxController {
  bool _signinInProgress = false;
  bool get signinInProgress => _signinInProgress;

  Future<bool> userSignIn(
      {required String email, required String password}) async {
    _signinInProgress = true;
    update();

    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };
    final NetworkResponse networkResponse = await NetworkCaller().postRequest(
      url: Urls.login,
      body: requestBody,
      isLogin: true,
    );
    _signinInProgress = false;
    update();

    if (networkResponse.isSuccess == true) {
      AuthUserModel authUserModel =
          AuthUserModel.fromJson(networkResponse.body!);
      await AuthUtility.saveUserInfo(authUserModel);
      return true;
    } else {
      return false;
    }
  }
}
