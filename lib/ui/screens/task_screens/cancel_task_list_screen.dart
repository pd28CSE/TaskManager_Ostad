import 'package:flutter/material.dart';
import 'package:testtaskmanager/ui/widgets/screen_background.dart';

import '../../../data/models/network_response.dart';
import '../../../data/models/user_task_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';

class CancleTaskListScreen extends StatefulWidget {
  const CancleTaskListScreen({super.key});

  @override
  State<CancleTaskListScreen> createState() => _CancleTaskListScreenState();
}

class _CancleTaskListScreenState extends State<CancleTaskListScreen> {
  late bool isDataFetchingInProgress;
  late List<UserTaskModel> cancleTaskList;

  @override
  void initState() {
    isDataFetchingInProgress = true;
    cancleTaskList = [];
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
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
                    itemCount: cancleTaskList.length,
                    itemBuilder: (cntxt, index) {
                      return TaskListTile(
                        userTask: cancleTaskList[index],
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
      ),
    );
  }

  Future<void> getUserTask() async {
    isDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskListByCancle);

    if (networkResponse.isSuccess == true) {
      UserTaskListModel userTaskListModel =
          UserTaskListModel.fromJson(networkResponse.body!);
      cancleTaskList = userTaskListModel.usertaskList;
    } else {
      showToastMessage('get Cancled task data failed!', Colors.red);
    }

    isDataFetchingInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool?> deleteTask(String taskId) async {
    isDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskDeleteById(taskId));
    if (networkResponse.isSuccess == true) {
      showToastMessage('Task successfully delete.', Colors.green);
      cancleTaskList.removeWhere((task) => task.id == taskId);
    } else {
      showToastMessage('Task delete failed!', Colors.red);
    }
    isDataFetchingInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool?> updateTaskByStatus(String taskId, String status) async {
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
