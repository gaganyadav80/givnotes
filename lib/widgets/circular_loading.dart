import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({Key? key, this.color = Colors.black, this.size = 30.0})
      : super(key: key);

  final Color color;

  /// Size is converted as per the device width
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.w,
      width: size.w,
      child: CircularProgressIndicator(
        strokeWidth: 1.0,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
