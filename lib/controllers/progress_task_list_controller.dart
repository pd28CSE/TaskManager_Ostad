import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/models/user_task_model.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class ProgressTaskListController extends GetxController {
  bool _isDataFetchingInProgress = false;
  List<UserTaskModel> progressTaskList = [];

  bool get isDataFetchingInProgress => _isDataFetchingInProgress;

  Future<bool?> getUserTask() async {
    _isDataFetchingInProgress = true;
    update();
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskListByProgress);
    _isDataFetchingInProgress = false;
    update();
    if (networkResponse.isSuccess == true) {
      UserTaskListModel userTaskListModel =
          UserTaskListModel.fromJson(networkResponse.body!);
      progressTaskList = userTaskListModel.usertaskList;
      update();
      return true;
    } else if (networkResponse.isSuccess == true &&
        networkResponse.statusCode != -1) {
      // showToastMessage('get progress task data failed!', Colors.red);
      return false;
    } else {
      return null;
    }
  }

  Future<bool?> deleteTask(String taskId) async {
    _isDataFetchingInProgress = true;
    update();
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskDeleteById(taskId));
    _isDataFetchingInProgress = false;
    update();
    if (networkResponse.isSuccess == true) {
      progressTaskList.removeWhere((task) => task.id == taskId);
      update();
      return true;
    } else if (networkResponse.isSuccess == false &&
        networkResponse.statusCode != -1) {
      return false;
    } else {
      return null;
    }
  }

  Future<bool?> updateTaskByStatus(String taskId, String status) async {
    _isDataFetchingInProgress = true;
    update();
    final NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskSatusUpdate(taskId, status));
    _isDataFetchingInProgress = false;
    update();

    if (networkResponse.isSuccess == true) {
      progressTaskList.removeWhere((task) => task.id == taskId);
      update();
      return true;
    } else if (networkResponse.isSuccess == false &&
        networkResponse.statusCode != -1) {
      return false;
    } else {
      return null;
    }
  }
}
