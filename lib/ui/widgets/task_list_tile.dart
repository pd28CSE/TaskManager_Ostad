import 'package:flutter/material.dart';

import '../../data/models/user_task_model.dart';
import '../utilitys/tast_status_option.dart';

class TaskListTile extends StatelessWidget {
  final UserTaskModel userTask;
  final Future<void> Function(String taskId) onDeleteTaskTap;
  final Future<void> Function(String taskId, String status)
      onUpdateTaskStatusTap;
  late TaskStatusList currentStatus;

  final Map<String, Color> progressColor = {
    'New': Colors.blue,
    'Cancled': Colors.red,
    'Progress': Colors.purple,
    'Completed': Colors.green,
  };
  TaskListTile({
    super.key,
    required this.userTask,
    required this.onDeleteTaskTap,
    required this.onUpdateTaskStatusTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userTask.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(userTask.description),
          Text(userTask.createdDate.replaceAll('-', '/')),
          Row(
            children: <Widget>[
              Chip(
                backgroundColor: progressColor[userTask.status],
                label: Text(
                  userTask.status,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  isTaskDeleteConfirm(context).then((value) {
                    if (value == true) {
                      onDeleteTaskTap(userTask.id);
                    }
                  });
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red.shade300,
                ),
              ),
              IconButton(
                onPressed: () {
                  changeTaskStatus(context);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
      onLongPress: () {
        changeTaskStatus(context);
      },
    );
  }

  void initialStatus() {
    if (userTask.status.contains(TaskStatusList.New.name)) {
      currentStatus = TaskStatusList.New;
    } else if (userTask.status.contains(TaskStatusList.Progress.name)) {
      currentStatus = TaskStatusList.Progress;
    } else if (userTask.status.contains(TaskStatusList.Completed.name)) {
      currentStatus = TaskStatusList.Completed;
    } else if (userTask.status.contains(TaskStatusList.Cancled.name)) {
      currentStatus = TaskStatusList.Cancled;
    }
  }

  Future<bool?> isTaskDeleteConfirm(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          title: const Text('Are You Confirm?'),
          content: const Text('Once if you delete you can not get it back.'),
          actions: <OutlinedButton>[
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> changeTaskStatus(BuildContext context) async {
    initialStatus();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (cntxt) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: StatefulBuilder(
            builder: (newcntxt, newState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<TaskStatusList>(
                    value: TaskStatusList.New,
                    groupValue: currentStatus,
                    title: Text(TaskStatusList.New.name),
                    onChanged: (value) {
                      currentStatus = value!;
                      newState(() {});
                    },
                  ),
                  RadioListTile<TaskStatusList>(
                    value: TaskStatusList.Progress,
                    groupValue: currentStatus,
                    title: Text(TaskStatusList.Progress.name),
                    onChanged: (value) {
                      currentStatus = value!;
                      newState(() {});
                    },
                  ),
                  RadioListTile<TaskStatusList>(
                    value: TaskStatusList.Cancled,
                    groupValue: currentStatus,
                    title: Text(TaskStatusList.Cancled.name),
                    onChanged: (value) {
                      currentStatus = value!;
                      newState(() {});
                    },
                  ),
                  RadioListTile<TaskStatusList>(
                    value: TaskStatusList.Completed,
                    groupValue: currentStatus,
                    title: Text(TaskStatusList.Completed.name),
                    onChanged: (value) {
                      currentStatus = value!;
                      newState(() {});
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await onUpdateTaskStatusTap(
                          userTask.id, currentStatus.name);
                    },
                    child: const Text('Save'),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
