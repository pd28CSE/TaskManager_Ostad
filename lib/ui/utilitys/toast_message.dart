import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void showToastMessage(String message, Color backgroundColor) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void getXSnackbar({
  required String title,
  required String content,
  bool isSuccess = true,
  Color backgroundColor = Colors.deepPurple,
  SnackPosition snackBarPosition = SnackPosition.BOTTOM,
}) {
  final Color color = isSuccess == true ? Colors.green : Colors.red;
  final LinearGradient linearGradient = LinearGradient(
    colors: [
      isSuccess == true ? Colors.green.shade900 : Colors.red.shade900,
      Colors.green,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  Get.snackbar(
    title,
    content,
    backgroundColor: backgroundColor,
    snackPosition: snackBarPosition,
    colorText: color,
    backgroundGradient: linearGradient,
  );
}
