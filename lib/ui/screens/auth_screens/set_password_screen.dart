import 'package:flutter/material.dart';

import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import 'login_screen.dart';

class SetPasswordScreen extends StatefulWidget {
  static const String routeName = 'set-password-screen/';
  final String email;
  final String otp;
  const SetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late bool isLoading;
  late bool isPasswordHidden;
  late bool isConfirmPasswordHidden;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    isLoading = false;
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
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate() == true) {
                          await resetPassword();
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, String> requestBody = {
      'email': widget.email,
      'OTP': widget.otp,
      'password': confirmPasswordController.text,
    };
    NetworkResponse responseBody = await NetworkCaller()
        .postRequest(url: Urls.resetUserPassword, body: requestBody);
    if (responseBody.body!['status'] == 'success') {
      showToastMessage(
          'Password reset successful., Now you can login.', Colors.green);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (cntxt) => const LoginScreen(),
          ),
          (route) => false,
        );
      }
    } else {
      showToastMessage('Password reset failed!', Colors.red);
    }
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }
}
