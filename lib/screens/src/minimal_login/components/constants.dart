import 'package:flutter/material.dart';

final kBorderRadius = BorderRadius.circular(7);

final kInputBorderStyle = OutlineInputBorder(
  borderRadius: kBorderRadius,
  borderSide: BorderSide(
    width: 1.0,
    color: Colors.grey[500].withOpacity(0.5),
  ),
);
