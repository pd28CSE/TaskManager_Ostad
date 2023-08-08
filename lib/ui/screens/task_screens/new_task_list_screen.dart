import 'package:flutter/material.dart';

import '../../../data/models/network_response.dart';
import '../../../data/models/task_status_count.dart';
import '../../../data/models/user_task_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';
import './add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  final void Function(int) onChangeScreen;
  const NewTaskListScreen({super.key, required this.onChangeScreen});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  late bool isTaskDataFetchingInProgress;
  late bool isTaskStatusDataFetchingInProgress;
  late List<UserTaskModel> newTaskList;
  late TaskStatusCount taskStatusCount;
  final Map<String, int> statusCount = {
    'New': 0,
    'Progress': 0,
    'Cancled': 0,
    'Completed': 0,
  };

  @override
  void initState() {
    isTaskDataFetchingInProgress = true;
    isTaskStatusDataFetchingInProgress = true;
    newTaskList = [];

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserTask();
      getTaskListStatus();
    });
  }

  @override
  void dispose() {
    newTaskList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: <Widget>[
            const UserProfileBanner(),
            const SizedBox(height: 10),
            Visibility(
              visible: isTaskStatusDataFetchingInProgress == false,
              replacement: const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.onChangeScreen(0);
                      },
                      child: SummaryCard(
                        title: 'New',
                        number: statusCount['New']!,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.onChangeScreen(1);
                      },
                      child: SummaryCard(
                        title: 'In Progress',
                        number: statusCount['Progress']!,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.onChangeScreen(2);
                      },
                      child: SummaryCard(
                        title: 'Cancle',
                        number: statusCount['Cancled']!,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.onChangeScreen(3);
                      },
                      child: SummaryCard(
                        title: 'Completed',
                        number: statusCount['Completed']!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: getUserTask,
                child: Visibility(
                  visible: isTaskDataFetchingInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: newTaskList.length,
                    itemBuilder: (cntxt, index) {
                      return TaskListTile(
                        userTask: newTaskList[index],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (cntxt) => const AddNewTaskScreen()),
          ).then((value) async {
            await getTaskListStatus();
            await getUserTask();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getUserTask() async {
    isTaskDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskListByNew);

    if (networkResponse.isSuccess == true) {
      UserTaskListModel userTaskListModel =
          UserTaskListModel.fromJson(networkResponse.body!);
      newTaskList = userTaskListModel.usertaskList;
    } else {
      showToastMessage('get new task data failed!', Colors.red);
    }
    isTaskDataFetchingInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getTaskListStatus() async {
    isTaskStatusDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    if (networkResponse.isSuccess == true) {
      TaskStatusCount responseBody =
          TaskStatusCount.fromJson(networkResponse.body!);
      taskStatusCount = responseBody;

      for (var status in taskStatusCount.data!) {
        statusCount[status.id!] = status.sum!;
      }
    } else if (networkResponse.isSuccess == false) {
      showToastMessage('Summary data get failed!', Colors.red);
    }

    isTaskStatusDataFetchingInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    isTaskDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskDeleteById(taskId));
    if (networkResponse.isSuccess == true) {
      showToastMessage('Task successfully delete.', Colors.green);
      newTaskList.removeWhere((task) => task.id == taskId);
      await getTaskListStatus();
    } else {
      showToastMessage('Task delete failed!', Colors.red);
    }

    isTaskDataFetchingInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> updateTaskByStatus(String taskId, String status) async {
    isTaskDataFetchingInProgress = true;
    isTaskStatusDataFetchingInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse networkResponse =
        await NetworkCaller().getRequest(Urls.taskSatusUpdate(taskId, status));

    if (networkResponse.isSuccess == true) {
      showToastMessage('Update Successful', Colors.green);
      await getUserTask();
      await getTaskListStatus();
    } else {
      showToastMessage('Update request failed!', Colors.red);
    }
  }
}
