import 'package:flutter/material.dart';

import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
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
  late bool taskSavingInProgress;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    taskSavingInProgress = false;
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
                      buildSubmitButton(),
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

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      onPressed: taskSavingInProgress == true
          ? null
          : () {
              if (formKey.currentState!.validate() == false) {
                return;
              } else {
                saveTask();
              }
            },
      child: Visibility(
        visible: taskSavingInProgress == false,
        replacement: const CircularProgressIndicator(color: Colors.green),
        child: const Text('Save'),
      ),
    );
  }

  Future<void> saveTask() async {
    taskSavingInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'status': 'New',
    };

    final NetworkResponse networkResponse = await NetworkCaller().postRequest(
      url: Urls.createTask,
      body: requestBody,
    );

    taskSavingInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (networkResponse.isSuccess) {
      clearForm();
      showToastMessage('Task added successfully.', Colors.green);
    } else {
      showToastMessage('Task add failed!', Colors.red);
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
  }
}
