import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class VSpace extends StatelessWidget {
  const VSpace(this.height, {Key? key}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

// HSpace
class HSpace extends StatelessWidget {
  const HSpace(this.width, {Key? key}) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

Future<bool?> showToast(String msg) {
  return Fluttertoast.showToast(msg: msg);
}

void showGetSnackBar(String msg, {Icon? icon}) {
  Get.closeAllSnackbars();
  Get.showSnackbar(GetSnackBar(message: msg, icon: icon));
}

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void delayedOnPressed(VoidCallback onPressed) {
  Future.delayed(const Duration(milliseconds: 50), onPressed);
}
