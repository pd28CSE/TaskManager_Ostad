import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/ermail_verification_controller.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import './pin_verification_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String routeName = '/email-verification-screen';
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late TextEditingController emailController;
  late GlobalKey<FormState> formKey;

  final EmailVerificationController emailVerificationController =
      Get.find<EmailVerificationController>();

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '6 digit verification pin will send to your email address.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter your email';
                        } else if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!.trim()) ==
                            false) {
                          return 'Enter a valid email.';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GetBuilder<EmailVerificationController>(
                      builder: (emailVerifyController) {
                    return ElevatedButton(
                      onPressed: emailVerifyController.emailVerifyInProgress ==
                              true
                          ? null
                          : () {
                              if (formKey.currentState!.validate() == false) {
                                return;
                              } else {
                                emailVerifyController
                                    .verifyUserEmail(
                                        emailController.text.trim())
                                    .then((value) {
                                  if (value == true) {
                                    getXSnackbar(
                                      title: 'Attention!',
                                      content:
                                          '6 digit verification pin is send.',
                                    );
                                    Get.to(() => PinVerificationScreen(
                                        email: emailController.text.trim()));

                                    // showToastMessage(
                                    //   '6 digit verification pin is send.',
                                    //   Colors.green,
                                    // );
                                  } else if (value == false) {
                                    getXSnackbar(
                                      title: 'Attention!',
                                      content: 'Enter valid email!',
                                      isSuccess: false,
                                    );
                                    // showToastMessage(
                                    //   'Enter valid email!',
                                    //   Colors.red,
                                    // );
                                  }
                                });
                              }
                            },
                      child: Visibility(
                        visible: emailVerifyController.emailVerifyInProgress ==
                            false,
                        replacement: const CircularProgressIndicator(
                            color: Colors.green),
                        child: const Text('Next'),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
