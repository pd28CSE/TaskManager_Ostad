import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';
import 'auth_utility.dart';

class ProfileUpdateController extends GetxController {
  bool _isUpdateInProgress = false;

  bool get isUpdateInProgress => _isUpdateInProgress;
  final AuthUtility authUtilityController = Get.find<AuthUtility>();

  Future<bool?> updateUserInfo({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String password,
    required String image,
  }) async {
    _isUpdateInProgress = true;
    update();

    Map<String, String> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": phoneNo,
    };
    if (password.isNotEmpty) {
      requestBody["password"] = password;
    }
    if (image.isNotEmpty) {
      requestBody["photo"] = image;
    }
    NetworkResponse networkResponse = await NetworkCaller().postRequest(
      url: Urls.updateUserPprofile,
      body: requestBody,
    );
    _isUpdateInProgress = false;
    update();

    if (networkResponse.isSuccess == true) {
      return true;
    } else if (networkResponse.isSuccess == false &&
        networkResponse.statusCode != -1) {
      return false;
    } else {
      return null;
    }
  }
}
