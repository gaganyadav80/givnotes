import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FloatingModal extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const FloatingModal({Key key, @required this.child, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: !Platform.isIOS || !Platform.isMacOS ? const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0) : EdgeInsets.symmetric(horizontal: 20.0),
        // padding: EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          color: backgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ),
    );
  }
}

Future<T> showFloatingModalBottomSheet<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  Color backgroundColor,
}) async {
  final result = await showCustomModalBottomSheet(
      context: context,
      builder: builder,
      containerWidget: (_, animation, child) => FloatingModal(
            child: child,
            backgroundColor: backgroundColor,
          ),
      expand: false);

  return result;
}
