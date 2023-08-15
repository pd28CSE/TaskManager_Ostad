import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/new_task_list_controller.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';
import './add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  static const String routeName = '/new-task-list-screen';
  final void Function(int) onChangeScreen;
  const NewTaskListScreen({super.key, required this.onChangeScreen});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  final NewTaskListController newTaskListController =
      Get.find<NewTaskListController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      newTaskListController.getTaskListStatus().then((value) {
        if (value == null) {
          getXSnackbar(
            title: 'Error!',
            content: 'Some thing is wrong!',
            isSuccess: false,
          );
        } else if (value == false) {
          getXSnackbar(
            title: 'Failed!',
            content: 'Summary data get failed!',
            isSuccess: false,
          );
        }
      });
      newTaskListController.getNewTaskList().then((value) {
        if (value == null) {
          getXSnackbar(
            title: 'Error!',
            content: 'Some thing is wrong!',
            isSuccess: false,
          );
        } else if (value == false) {
          getXSnackbar(
            title: 'Failed!',
            content: 'New task list get failed!',
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
            const UserProfileBanner(),
            const SizedBox(height: 10),
            GetBuilder<NewTaskListController>(
              builder: (taskListStatus) {
                return Visibility(
                  visible: taskListStatus.isTaskDataFetchingInProgress == false,
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
                            number: taskListStatus.statusCount['New']!,
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
                            number: taskListStatus.statusCount['Progress']!,
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
                            number: taskListStatus.statusCount['Cancled']!,
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
                            number: taskListStatus.statusCount['Completed']!,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: GetBuilder<NewTaskListController>(
                  builder: (newTaskController) {
                return RefreshIndicator(
                  onRefresh: newTaskController.getNewTaskList,
                  child: Visibility(
                    visible:
                        newTaskController.isTaskDataFetchingInProgress == false,
                    replacement:
                        const Center(child: CircularProgressIndicator()),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(10),
                      itemCount: newTaskController.newTaskList.length,
                      itemBuilder: (cntxt, index) {
                        return TaskListTile(
                          userTask: newTaskController.newTaskList[index],
                          onDeleteTaskTap: newTaskController.deleteTask,
                          onUpdateTaskStatusTap:
                              newTaskController.updateTaskByStatus,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddNewTaskScreen())!.then((value) async {
            await newTaskListController.getTaskListStatus();
            await newTaskListController.getNewTaskList();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
