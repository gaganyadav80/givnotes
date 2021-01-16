import 'package:flutter/material.dart';

void initializeUtils(BuildContext context) async {
  screenSize = MediaQuery.of(context).size;
}

Size screenSize;
