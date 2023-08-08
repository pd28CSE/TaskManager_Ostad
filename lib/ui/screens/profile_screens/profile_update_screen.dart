import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/network_response.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/user_profile_banner.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static const String routeName = 'registration-screen/';
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late AuthUserModel auth;
  late bool isUpdateInProgress;
  late bool isPasswordHidden;
  late bool isConfirmPasswordHidden;
  late GlobalKey<FormState> formKey;
  late TextEditingController imagePathController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late Uint8List imageBytes;

  @override
  void initState() {
    auth = AuthUtility.userModel;
    isUpdateInProgress = false;
    isPasswordHidden = true;
    isConfirmPasswordHidden = true;
    formKey = GlobalKey<FormState>();
    imagePathController = TextEditingController();
    firstNameController = TextEditingController(text: auth.data!.firstName);
    lastNameController = TextEditingController(text: auth.data!.lastName);
    phoneNumberController = TextEditingController(text: auth.data!.mobile);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: <Widget>[
            const Material(
              elevation: 8,
              child: UserProfileBanner(
                isInProfileUpdateScreen: true,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Update Profile',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        if (imagePathController.text.isNotEmpty)
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(imageBytes),
                            ),
                          ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: imagePathController,
                          readOnly: true,
                          decoration: InputDecoration(
                            helperText: 'Optional',
                            prefixIcon: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black54,
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await pickImageFromGallery();
                              },
                              child: const Text('Image'),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return null;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: auth.data!.email,
                          // decoration: const InputDecoration(
                          //   labelText: 'Email',
                          // ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            helperText: 'Optional',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                              icon: Visibility(
                                visible: isPasswordHidden,
                                replacement: const Icon(Icons.remove_red_eye),
                                child: const Icon(Icons.visibility_off),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          obscureText: isPasswordHidden,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return null;
                            } else if (value !=
                                confirmPasswordController.text) {
                              return 'Enter new Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            helperText: 'Optional',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordHidden =
                                      !isConfirmPasswordHidden;
                                });
                              },
                              icon: Visibility(
                                visible: isConfirmPasswordHidden,
                                replacement: const Icon(Icons.remove_red_eye),
                                child: const Icon(Icons.visibility_off),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          obscureText: isConfirmPasswordHidden,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return null;
                            } else if (value!.length < 8) {
                              return 'Minimum length must be 8 characters long';
                            } else if (value != passwordController.text) {
                              return 'Password and Confirm Password does not match';
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ImageSource?> storageSelection() {
    return showDialog<ImageSource?>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
            content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () {
                if (mounted) {
                  Navigator.pop(context, ImageSource.camera);
                }
              },
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Camera'),
            ),
            ListTile(
              onTap: () {
                if (mounted) {
                  Navigator.pop(context, ImageSource.gallery);
                }
              },
              leading: const Icon(Icons.camera),
              title: const Text('Gallery'),
            ),
          ],
        ));
      },
    );
  }

  Future<void> pickImageFromGallery() async {
    try {
      ImageSource? imageSource = await storageSelection();
      if (imageSource == null) {
        return;
      }
      final XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        imagePathController.text = image.name;
        imageBytes = File(image.path).readAsBytesSync();
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      onPressed: isUpdateInProgress == true
          ? null
          : () async {
              if (formKey.currentState!.validate() == false) {
                return;
              } else {
                await updateUserInfo();
              }
            },
      child: Visibility(
        visible: isUpdateInProgress == false,
        replacement: const CircularProgressIndicator(color: Colors.green),
        child: const Text('Update'),
      ),
    );
  }

  Future<void> updateUserInfo() async {
    isUpdateInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, String> requestBody = {
      "email": auth.data!.email!,
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "mobile": phoneNumberController.text.trim(),
    };
    if (passwordController.text.isNotEmpty) {
      requestBody["password"] = passwordController.text;
    }
    if (imagePathController.text.isNotEmpty) {
      requestBody["photo"] = base64Encode(imageBytes);
    }
    NetworkResponse networkResponse = await NetworkCaller().postRequest(
      url: Urls.updateUserPprofile,
      body: requestBody,
    );

    if (networkResponse.isSuccess == true) {
      showToastMessage('Profile Update Successfull.', Colors.green);
      auth.data!.firstName = firstNameController.text;
      auth.data!.lastName = lastNameController.text;
      auth.data!.mobile = phoneNumberController.text;
      await AuthUtility.updateUserInfo(auth.data!);
    } else {
      showToastMessage('Profile Update failed!', Colors.red);
    }

    isUpdateInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
}
