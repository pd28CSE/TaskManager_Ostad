import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/cancle_task_list_controller.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';
import '../../utilitys/toast_message.dart';

class CancleTaskListScreen extends StatefulWidget {
  const CancleTaskListScreen({super.key});

  @override
  State<CancleTaskListScreen> createState() => _CancleTaskListScreenState();
}

class _CancleTaskListScreenState extends State<CancleTaskListScreen> {
  final CancleTaskListController cancleTaskListController =
      Get.find<CancleTaskListController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      cancleTaskListController.getUserTask().then((value) {
        if (value == null) {
          getXSnackbar(
            title: 'Error!',
            content: 'Some thing is wrong!',
            isSuccess: false,
          );
        } else if (value == false) {
          getXSnackbar(
            title: 'Failed!',
            content: 'Cancled task list get failed!',
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
              child: GetBuilder<CancleTaskListController>(
                builder: (cancleTaskController) {
                  return RefreshIndicator(
                    onRefresh: cancleTaskController.getUserTask,
                    child: Visibility(
                      visible: cancleTaskController.isDataFetchingInProgress ==
                          false,
                      replacement:
                          const Center(child: CircularProgressIndicator()),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: cancleTaskController.cancleTaskList.length,
                        itemBuilder: (cntxt, index) {
                          return TaskListTile(
                            userTask:
                                cancleTaskController.cancleTaskList[index],
                            onDeleteTaskTap: cancleTaskController.deleteTask,
                            onUpdateTaskStatusTap:
                                cancleTaskController.updateTaskByStatus,
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
