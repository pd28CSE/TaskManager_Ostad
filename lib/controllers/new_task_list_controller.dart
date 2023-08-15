import 'package:get/get.dart';

import '../data/models/network_response.dart';
import '../data/models/task_status_count.dart';
import '../data/models/user_task_model.dart';
import '../data/services/network_caller.dart';
import '../data/utilitys/urls.dart';

class NewTaskListController extends GetxController {
  bool _isTaskDataFetchingInProgress = false;
  List<UserTaskModel> newTaskList = [];
  List<TaskStatusModel> taskStatusCount = [];
  final Map<String, int> statusCount = {
    'New': 0,
    'Progress': 0,
    'Cancled': 0,
    'Completed': 0,
  };

  bool get isTaskDataFetchingInProgress => _isTaskDataFetchingInProgress;

  void statusReinitialize() {
    statusCount['New'] = 0;
    statusCount['Progress'] = 0;
    statusCount['Cancled'] = 0;
    statusCount['Completed'] = 0;
  }

  Future<bool?> getTaskListStatus() async {
    statusReinitialize();
    _isTaskDataFetchingInProgress = true;
    update();
    final NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    _isTaskDataFetchingInProgress = false;
    update();

    if (networkResponse.isSuccess == true) {
      TaskStatusCount responseBody =
          TaskStatusCount.fromJson(networkResponse.body!);
      taskStatusCount = responseBody.data!;

      for (var status in taskStatusCount) {
        statusCount[status.id!] = status.sum!;
      }
      update();
      return true;
    } else if (networkResponse.isSuccess == false &&
        networkResponse.statusCode != -1) {
      return false;
    }
    return null;
  }

  Future<bool?> getNewTaskList() async {
    _isTaskDataFetchingInProgress = true;
    update();
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskListByNew);
    _isTaskDataFetchingInProgress = false;
    update();

    if (networkResponse.isSuccess == true) {
      UserTaskListModel userTaskListModel =
          UserTaskListModel.fromJson(networkResponse.body!);
      newTaskList = userTaskListModel.usertaskList;
      update();
      return true;
    } else if (networkResponse.isSuccess == false &&
        networkResponse.statusCode != -1) {
      return false;
    }
    return null;
  }

  Future<bool?> deleteTask(String taskId) async {
    _isTaskDataFetchingInProgress = true;
    update();
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskDeleteById(taskId));
    _isTaskDataFetchingInProgress = false;
    update();

    if (networkResponse.isSuccess == true) {
      newTaskList.removeWhere((task) => task.id == taskId);
      statusCount['New'] = statusCount['New']! - 1;
      update();
      return true;
    } else if (networkResponse.isSuccess == false &&
        networkResponse.statusCode != -1) {
      return false;
    }
    return null;
  }

  Future<bool?> updateTaskByStatus(String taskId, String status) async {
    _isTaskDataFetchingInProgress = true;
    update();
    final NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskSatusUpdate(taskId, status));

    _isTaskDataFetchingInProgress = false;
    update();

    if (networkResponse.isSuccess == true) {
      newTaskList.removeWhere((task) => task.id == taskId);
      await getTaskListStatus();
      return true;
    } else if (networkResponse.isSuccess == false &&
        networkResponse.statusCode != -1) {
      return false;
    }
    return null;
  }
}
