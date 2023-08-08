import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utilitys/urls.dart';
import '../../../styles/style.dart';
import '../../utilitys/toast_message.dart';
import '../../widgets/screen_background.dart';
import './set_password_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  static const String routeName = 'pin-verification-screen/';
  final String email;
  const PinVerificationScreen({super.key, required this.email});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  late TextEditingController pinController;
  late GlobalKey<FormState> formKey;
  late bool isLoading;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    isLoading = false;
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
                  buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      onPressed: isLoading == true
          ? null
          : () async {
              if (formKey.currentState!.validate() == false) {
                return;
              } else {
                await verifyOTP(widget.email, pinController.text.trim());
              }
            },
      child: Visibility(
        visible: isLoading == false,
        replacement: const CircularProgressIndicator(color: Colors.green),
        child: const Text('Confirm'),
      ),
    );
  }

  Future<void> verifyOTP(String email, String otp) async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse responseBody =
        await NetworkCaller().getRequest(Urls.otpVerification(email, otp));
    if (responseBody.body!['status'] == 'success') {
      formKey.currentState!.reset();
      showToastMessage('OTP verification successful.', Colors.green);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (cntxt) => SetPasswordScreen(email: email, otp: otp),
          ),
        );
      }
    } else {
      showToastMessage('Wrong OTP!', Colors.red);
    }
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }
}
