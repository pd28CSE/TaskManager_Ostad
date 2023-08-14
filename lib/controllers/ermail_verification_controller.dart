import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class EmailVerificationController extends GetxController {
  bool _emailVerifyInProgress = false;

  bool get emailVerifyInProgress => _emailVerifyInProgress;
  Future<bool> verifyUserEmail(String email) async {
    _emailVerifyInProgress = true;
    update();
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.userRecoverVerifyEmail(email));
    _emailVerifyInProgress = false;
    update();
    if (networkResponse.body!['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }
}
