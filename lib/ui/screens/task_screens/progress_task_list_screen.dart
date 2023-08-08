import 'package:flutter/material.dart';

import '../../../data/models/network_response.dart';
import '../../../data/models/user_task_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  late bool isDataFetchingInProgress;
  late List<UserTaskModel> progressTaskList;

  @override
  void initState() {
    isDataFetchingInProgress = true;
    progressTaskList = [];
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const UserProfileBanner(),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: getUserTask,
              child: Visibility(
                visible: isDataFetchingInProgress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  itemCount: progressTaskList.length,
                  itemBuilder: (cntxt, index) {
                    return TaskListTile(
                      userTask: progressTaskList[index],
                      onDeleteTaskTap: deleteTask,
                      onUpdateTaskStatusTap: updateTaskByStatus,
                    );
                  },
                  separatorBuilder: (cntxt, index) => const Divider(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUserTask() async {
    isDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskListByProgress);

    if (networkResponse.isSuccess == true) {
      UserTaskListModel userTaskListModel =
          UserTaskListModel.fromJson(networkResponse.body!);
      progressTaskList = userTaskListModel.usertaskList;
    } else {
      showToastMessage('get progress task data failed!', Colors.red);
    }
    isDataFetchingInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    isDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskDeleteById(taskId));
    if (networkResponse.isSuccess == true) {
      showToastMessage('Task successfully delete.', Colors.green);
      progressTaskList.removeWhere((task) => task.id == taskId);
    } else {
      showToastMessage('Task delete failed!', Colors.red);
    }

    isDataFetchingInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateTaskByStatus(String taskId, String status) async {
    isDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskSatusUpdate(taskId, status));

    if (networkResponse.isSuccess == true) {
      showToastMessage('Update Successful', Colors.green);
      await getUserTask();
    } else {
      showToastMessage('Update request failed!', Colors.red);
    }
  }
}
