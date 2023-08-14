import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class SetPasswordController extends GetxController {
  bool _passwordResetIsInProgress = false;

  bool get passwordResetIsInProgress => _passwordResetIsInProgress;

  Future<bool> resetPassword(
      {required String email,
      required String pin,
      required String password}) async {
    _passwordResetIsInProgress = true;
    update();

    Map<String, String> requestBody = {
      'email': email,
      'OTP': pin,
      'password': password,
    };
    NetworkResponse responseBody = await NetworkCaller()
        .postRequest(url: Urls.resetUserPassword, body: requestBody);

    _passwordResetIsInProgress = false;
    update();

    if (responseBody.body!['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }
}
