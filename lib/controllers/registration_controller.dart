import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class RegistrationController extends GetxController {
  bool _signUpInProgress = false;

  bool get signUpInProgress => _signUpInProgress;

  Future<bool> userSignUp({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String password,
    String photo = '',
  }) async {
    _signUpInProgress = true;
    update();

    final Map<String, dynamic> body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': phoneNo,
      'password': password,
      'photo': '',
    };
    final NetworkResponse networkResponse =
        await NetworkCaller().postRequest(url: Urls.registration, body: body);

    _signUpInProgress = false;
    update();
    if (networkResponse.isSuccess == true) {
      return true;
    } else {
      return false;
    }
  }
}
