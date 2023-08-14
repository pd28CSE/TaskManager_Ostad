import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class PinVerificationController extends GetxController {
  bool _pinVerificationInProgress = false;
  bool get pinVerificationInProgress => _pinVerificationInProgress;

  Future<bool> verifyPIN({required String email, required String pin}) async {
    _pinVerificationInProgress = true;
    update();
    NetworkResponse responseBody =
        await NetworkCaller().getRequest(Urls.otpVerification(email, pin));
    _pinVerificationInProgress = false;
    update();

    if (responseBody.body!['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }
}
