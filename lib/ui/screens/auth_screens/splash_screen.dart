import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../data/models/auth_utility.dart';
import '../../utilitys/assets_utils.dart';
import '../../widgets/screen_background.dart';
import '../task_screens/bottom_nav_base_screen.dart';
import './login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash-screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToLoginScreen();
    super.initState();
  }

  Future<void> navigateToLoginScreen() async {
    bool isLogedIn = await AuthUtility.isUserLoggedIn();

    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        Get.offAll(() => isLogedIn == false
            ? const LoginScreen()
            : const BottomNavBaseScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(AssetsUtils.logoSVG),
        ),
      ),
    );
  }
}
