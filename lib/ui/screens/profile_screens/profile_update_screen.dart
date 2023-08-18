import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../../controllers/auth_utility.dart';
import '../../../controllers/profile_update_controller.dart';
import '../../../data/models/user_model.dart';
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
  final AuthUtility authUtilityController = Get.find<AuthUtility>();
  final ProfileUpdateController profileUpdateController =
      Get.find<ProfileUpdateController>();

  @override
  void initState() {
    auth = AuthUtility.userModel;
    isPasswordHidden = true;
    isConfirmPasswordHidden = true;
    formKey = GlobalKey<FormState>();
    imagePathController = TextEditingController();
    firstNameController = TextEditingController(text: auth.data!.firstName);
    lastNameController = TextEditingController(text: auth.data!.lastName);
    phoneNumberController = TextEditingController(text: auth.data!.mobile);
    profileUpdateController.imageBytesCon = base64Decode(auth.data!.photo!);
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
            UserProfileBanner(
              isInProfileUpdateScreen: true,
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
                        Center(
                          child: GetBuilder<ProfileUpdateController>(
                              builder: (controller) {
                            if (profileUpdateController
                                .imageBytesCon!.isNotEmpty) {
                              return CircleAvatar(
                                radius: 50,
                                backgroundImage: MemoryImage(
                                    profileUpdateController.imageBytesCon!),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                        ),
                        const SizedBox(height: 10),
                        GetBuilder<ProfileUpdateController>(
                          builder: (cntr) {
                            return TextFormField(
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
                                    await pickProfilePicture();
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
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: auth.data!.email,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                          ),
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
                        GetBuilder<ProfileUpdateController>(
                          builder: (profileUpdateController) {
                            return ElevatedButton(
                              onPressed: profileUpdateController
                                          .isUpdateInProgress ==
                                      true
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate() ==
                                          false) {
                                        return;
                                      } else {
                                        profileUpdateController
                                            .updateUserInfo(
                                          firstName:
                                              firstNameController.text.trim(),
                                          lastName:
                                              lastNameController.text.trim(),
                                          email: auth.data!.email!,
                                          phoneNo:
                                              phoneNumberController.text.trim(),
                                          image: imagePathController
                                                  .text.isNotEmpty
                                              ? base64Encode(imageBytes)
                                              : auth.data!.photo!,
                                          password: passwordController.text,
                                        )
                                            .then((value) {
                                          if (value == null) {
                                            getXSnackbar(
                                              title: 'Error!',
                                              content: 'Some thing is wrong',
                                              isSuccess: false,
                                            );
                                          } else if (value == false) {
                                            getXSnackbar(
                                              title: 'Failed!',
                                              content: 'Profile update failed.',
                                              isSuccess: false,
                                            );
                                          } else {
                                            auth.data!.firstName =
                                                firstNameController.text;
                                            auth.data!.lastName =
                                                lastNameController.text;
                                            auth.data!.mobile =
                                                phoneNumberController.text;
                                            auth.data!.photo =
                                                imagePathController.text.isEmpty
                                                    ? auth.data!.photo
                                                    : base64Encode(imageBytes);
                                            authUtilityController
                                                .updateUserInfo(auth.data!);
                                            getXSnackbar(
                                              title: 'Success!',
                                              content:
                                                  'Profile update successfull.',
                                            );
                                          }
                                        });
                                      }
                                    },
                              child: Visibility(
                                visible: profileUpdateController
                                        .isUpdateInProgress ==
                                    false,
                                replacement: const CircularProgressIndicator(
                                    color: Colors.green),
                                child: const Text('Update'),
                              ),
                            );
                          },
                        ),
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

  Future<void> pickProfilePicture() async {
    try {
      ImageSource? imageSource = await storageSelection();
      if (imageSource == null) {
        return;
      }
      final XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        imageBytes = File(image.path).readAsBytesSync();
        profileUpdateController.imageBytesCon = imageBytes;
        imagePathController.text = image.name;
        profileUpdateController.updateUI();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
