import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controllers/set_password_controller.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import './login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  static const String routeName = '/set-password-screen';
  final String email;
  final String pin;
  const SetPasswordScreen({super.key, required this.email, required this.pin});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late bool isPasswordHidden;
  late bool isConfirmPasswordHidden;
  final SetPasswordController setPasswordController =
      Get.find<SetPasswordController>();

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    isPasswordHidden = true;
    isConfirmPasswordHidden = true;
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Set New Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Minimum length password 8 character with Latter and Number combination',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                      maxLength: 20,
                      obscureText: isPasswordHidden,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
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
                      maxLength: 20,
                      obscureText: isConfirmPasswordHidden,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your Confirm Password';
                        } else if (value!.length < 8) {
                          return 'Minimum length must be 8 characters long';
                        } else if (value != passwordController.text) {
                          return 'Password and Confirm Password is not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    GetBuilder<SetPasswordController>(
                        builder: (setPassController) {
                      return ElevatedButton(
                        onPressed:
                            setPassController.passwordResetIsInProgress == true
                                ? null
                                : () {
                                    if (formKey.currentState!.validate() ==
                                        false) {
                                      return;
                                    } else {
                                      setPassController
                                          .resetPassword(
                                        email: widget.email,
                                        pin: widget.pin,
                                        password: passwordController.text,
                                      )
                                          .then((value) {
                                        if (value == true) {
                                          formKey.currentState!.reset();
                                          getXSnackbar(
                                            title: 'Success.',
                                            content:
                                                'Password reset successful., Now you can login.',
                                          );
                                          Get.offAll(() => const LoginScreen());
                                          // showToastMessage(
                                          //   'Password reset successful., Now you can login.',
                                          //   Colors.green,
                                          // );
                                          // Navigator.pushAndRemoveUntil(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (cntxt) =>
                                          //         const LoginScreen(),
                                          //   ),
                                          //   (route) => false,
                                          // );
                                        } else if (value == false) {
                                          getXSnackbar(
                                            title: 'Failed!',
                                            content: 'Wrong PIN!',
                                            isSuccess: false,
                                          );
                                          // showToastMessage('Password reset failed!', Colors.red);
                                        }
                                      });
                                    }
                                  },
                        child: Visibility(
                          visible:
                              setPassController.passwordResetIsInProgress ==
                                  false,
                          replacement: const CircularProgressIndicator(
                              color: Colors.green),
                          child: const Text('Confirm'),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
