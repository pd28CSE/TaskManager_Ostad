import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/completed_task_list_controller.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() =>
      _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  final CompletedTaskListController completedTaskListController =
      Get.find<CompletedTaskListController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      completedTaskListController.getUserTask().then((value) {
        if (value == null) {
          getXSnackbar(
            title: 'Error!',
            content: 'Some thing is wrong!',
            isSuccess: false,
          );
        } else if (value == false) {
          getXSnackbar(
            title: 'Failed!',
            content: 'Completed task list get failed!',
            isSuccess: false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: <Widget>[
            UserProfileBanner(),
            const SizedBox(height: 10),
            Expanded(
              child: GetBuilder<CompletedTaskListController>(
                builder: (completedTaskController) {
                  return RefreshIndicator(
                    onRefresh: completedTaskController.getUserTask,
                    child: Visibility(
                      visible:
                          completedTaskController.isDataFetchingInProgress ==
                              false,
                      replacement:
                          const Center(child: CircularProgressIndicator()),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount:
                            completedTaskController.completedTaskList.length,
                        itemBuilder: (cntxt, index) {
                          return TaskListTile(
                            userTask: completedTaskController
                                .completedTaskList[index],
                            onDeleteTaskTap: completedTaskController.deleteTask,
                            onUpdateTaskStatusTap:
                                completedTaskController.updateTaskByStatus,
                          );
                        },
                        separatorBuilder: (cntxt, index) => const Divider(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
