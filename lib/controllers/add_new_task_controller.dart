import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class AddNewTaskScreenController extends GetxController {
  bool _isTaskSavingInProgress = false;

  bool get isTaskSavingInProgress => _isTaskSavingInProgress;

  Future<bool?> saveTask(
      {required String taskTitle, required String taskDescription}) async {
    Map<String, dynamic> requestBody = {
      'title': taskTitle,
      'description': taskDescription,
      'status': 'New',
    };
    _isTaskSavingInProgress = true;
    update();

    final NetworkResponse networkResponse = await NetworkCaller().postRequest(
      url: Urls.createTask,
      body: requestBody,
    );

    _isTaskSavingInProgress = false;
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
