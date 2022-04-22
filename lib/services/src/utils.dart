import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

Future<bool?> showToast({String? msg}) {
  return Fluttertoast.showToast(msg: msg!);
}
