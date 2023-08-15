import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/add_new_task_controller.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/user_profile_banner.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  final AddNewTaskScreenController addNewTaskScreenController =
      Get.find<AddNewTaskScreenController>();

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: UserProfileBanner(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 25),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter Title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 7,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Enter Description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      GetBuilder<AddNewTaskScreenController>(
                          builder: (addTaskScreenController) {
                        return ElevatedButton(
                          onPressed: addTaskScreenController
                                      .isTaskSavingInProgress ==
                                  true
                              ? null
                              : () {
                                  if (formKey.currentState!.validate() ==
                                      false) {
                                    return;
                                  } else {
                                    addTaskScreenController
                                        .saveTask(
                                      taskTitle: titleController.text.trim(),
                                      taskDescription:
                                          descriptionController.text.trim(),
                                    )
                                        .then((value) {
                                      if (value == null) {
                                        getXSnackbar(
                                          title: 'New task add Error!',
                                          content: 'Some thing is wrong.',
                                          isSuccess: false,
                                        );
                                      } else if (value == false) {
                                        getXSnackbar(
                                          title: 'Failed!',
                                          content: 'Task add failed!',
                                          isSuccess: false,
                                        );
                                      } else {
                                        formKey.currentState!.reset();
                                        getXSnackbar(
                                          title: 'Success!',
                                          content: 'Task added successfully.',
                                          snackBarPosition: SnackPosition.TOP,
                                        );
                                      }
                                    });
                                  }
                                },
                          child: Visibility(
                            visible: addTaskScreenController
                                    .isTaskSavingInProgress ==
                                false,
                            replacement: const CircularProgressIndicator(
                                color: Colors.green),
                            child: const Text('Save'),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
