import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/progress_task_list_controller.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  final ProgressTaskListController progressTaskListController =
      Get.find<ProgressTaskListController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      progressTaskListController.getUserTask().then((value) {
        if (value == null) {
          getXSnackbar(
            title: 'Error!',
            content: 'Some thing is wrong!',
            isSuccess: false,
          );
        } else if (value == false) {
          getXSnackbar(
            title: 'Failed!',
            content: 'In Progress task list get failed!',
            isSuccess: false,
          );
        }
      });
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
            child: GetBuilder<ProgressTaskListController>(
                builder: (progressTaskController) {
              return RefreshIndicator(
                onRefresh: progressTaskController.getUserTask,
                child: Visibility(
                  visible:
                      progressTaskController.isDataFetchingInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: progressTaskController.progressTaskList.length,
                    itemBuilder: (cntxt, index) {
                      return TaskListTile(
                        userTask:
                            progressTaskController.progressTaskList[index],
                        onDeleteTaskTap: progressTaskController.deleteTask,
                        onUpdateTaskStatusTap:
                            progressTaskController.updateTaskByStatus,
                      );
                    },
                    separatorBuilder: (cntxt, index) => const Divider(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
