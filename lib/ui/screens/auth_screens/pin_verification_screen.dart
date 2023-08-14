import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../controllers/pin_verification_controller.dart';
import '../../../styles/style.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import './set_password_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  static const String routeName = '/pin-verification-screen';
  final String email;
  const PinVerificationScreen({super.key, required this.email});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  late TextEditingController pinController;
  late GlobalKey<FormState> formKey;
  final PinVerificationController pinVerificationController =
      Get.find<PinVerificationController>();

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'PIN Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'A 6 digit pin has been send to your phone number',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: PinCodeTextField(
                      controller: pinController,
                      autoDisposeControllers: false,
                      pinTheme: appOTPStyle(),
                      appContext: context,
                      length: 6,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Enter the valid PIN";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  GetBuilder<PinVerificationController>(
                      builder: (pinVerifyController) {
                    return ElevatedButton(
                      onPressed: pinVerifyController
                                  .pinVerificationInProgress ==
                              true
                          ? null
                          : () {
                              if (formKey.currentState!.validate() == false) {
                                return;
                              } else {
                                pinVerifyController
                                    .verifyPIN(
                                  email: widget.email,
                                  pin: pinController.text.trim(),
                                )
                                    .then((value) {
                                  if (value == true) {
                                    formKey.currentState!.reset();
                                    getXSnackbar(
                                      title: 'Success.',
                                      content: 'PIN verification successful.',
                                    );
                                    // showToastMessage(
                                    //   'OTP verification successful.',
                                    //   Colors.green,
                                    // );
                                    Get.to(() => SetPasswordScreen(
                                          email: widget.email,
                                          otp: pinController.text.trim(),
                                        ));
                                  } else if (value == false) {
                                    getXSnackbar(
                                      title: 'Failed!',
                                      content: 'Wrong PIN!',
                                      isSuccess: false,
                                    );
                                    // showToastMessage('Wrong OTP!', Colors.red);
                                  }
                                });
                              }
                            },
                      child: Visibility(
                        visible:
                            pinVerifyController.pinVerificationInProgress ==
                                false,
                        replacement: const CircularProgressIndicator(
                            color: Colors.green),
                        child: const Text('Confirm'),
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
