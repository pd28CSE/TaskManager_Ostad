import 'package:flutter/material.dart';

import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = 'registration-screen/';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late bool isPasswordHidden;
  late bool isConfirmPasswordHidden;
  late bool signUpInProgress;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    isPasswordHidden = true;
    isConfirmPasswordHidden = true;
    signUpInProgress = false;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Join With Us',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 1),
              Text(
                'Learn with rabbil hasan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
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
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: phoneController,
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
                                return 'Enter your Password';
                              } else if (value !=
                                  confirmPasswordController.text) {
                                return 'Password and Confirm Password is not match';
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
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            obscureText: isConfirmPasswordHidden,
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
                          buildSubmitButton(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text('Have an account?'),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Sign In'),
                              ),
                            ],
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
      ),
    );
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      onPressed: signUpInProgress == true
          ? null
          : () {
              if (formKey.currentState!.validate() == false) {
                return;
              } else {
                userSignUp();
              }
            },
      child: Visibility(
        visible: signUpInProgress == false,
        replacement: const CircularProgressIndicator(
          color: Colors.green,
        ),
        child: const Text('Registration'),
      ),
    );
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> userSignUp() async {
    if (mounted) {
      signUpInProgress = true;
      setState(() {});
    }

    final Map<String, dynamic> body = {
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'mobile': phoneController.text.trim(),
      'password': passwordController.text,
      'photo': '',
    };
    final NetworkResponse networkResponse =
        await NetworkCaller().postRequest(url: Urls.registration, body: body);
    clearForm();
    if (mounted) {
      signUpInProgress = false;
      setState(() {});
    }
    if (networkResponse.isSuccess == true) {
      showToastMessage('Registration success!', Colors.green);
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Registration success!'),
      //     ),
      //   );
      // }
    } else {
      showToastMessage('Registration failed!', Colors.red);
    }
  }
}
