import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
