import 'package:flutter/material.dart';

import 'package:get/get.dart';

import './ui/screens/auth_screens/splash_screen.dart';
import './controllers/login_controller.dart';
import './controllers/registration_controller.dart';
import './controllers/ermail_verification_controller.dart';
import './controllers/pin_verification_controller.dart';

class TaskManager extends StatefulWidget {
  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManager.globalKey,
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color.fromRGBO(44, 62, 80, 1.0),
            fontSize: 28,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            color: Color.fromRGBO(135, 142, 150, 1.0),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 1.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(45),
            backgroundColor: const Color.fromRGBO(33, 191, 115, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.light,
      initialBinding: ControllerBinding(),
      initialRoute: SplashScreen.routeName,
      getPages: [
        GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
      ],
    );
  }
}

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
    Get.put<RegistrationController>(RegistrationController());
    Get.put<EmailVerificationController>(EmailVerificationController());
    Get.put<PinVerificationController>(PinVerificationController());
  }
}
