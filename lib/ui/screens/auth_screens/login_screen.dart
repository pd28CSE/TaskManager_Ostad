import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import '../task_screens/bottom_nav_base_screen.dart';
import './email_verification_screen.dart';
import './registrations_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login-screen/';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late bool isPasswordHidden;
  final LoginController loginController = Get.find<LoginController>();

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    isPasswordHidden = true;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Learn with rabbil hasan',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your Email';
                        }
                        return null;
                      },
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
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your Password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    GetBuilder<LoginController>(
                      builder: (contrl) {
                        return ElevatedButton(
                          onPressed: contrl.signinInProgress == true
                              ? null
                              : () {
                                  if (formKey.currentState!.validate() ==
                                      false) {
                                    return;
                                  } else {
                                    contrl
                                        .userSignIn(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    )
                                        .then((value) {
                                      if (value == true) {
                                        clearForm();
                                        Get.offAll(
                                            () => const BottomNavBaseScreen());
                                      } else if (value == false) {
                                        Get.snackbar(
                                          'Failed!',
                                          'Incorrect email or password!',
                                          snackPosition: SnackPosition.BOTTOM,
                                          colorText: Colors.red,
                                          backgroundGradient: LinearGradient(
                                            colors: [
                                              Colors.red.shade900,
                                              Colors.green,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        );
                                        // showToastMessage(
                                        //   'Incorrect email or password!',
                                        //   Colors.red,
                                        // );
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   const SnackBar(
                                        //     content: Text('Incorrect email or password!'),
                                        //   ),
                                        // );
                                      }
                                    });
                                  }
                                },
                          child: Visibility(
                            visible: contrl.signinInProgress == false,
                            replacement: const CircularProgressIndicator(
                              color: Colors.green,
                            ),
                            child: const Text('Login'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => const EmailVerificationScreen());
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Don\'t have an account?'),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            Get.to(() => const RegistrationScreen());
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
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

  void clearForm() {
    emailController.clear();
    passwordController.clear();
  }
}
