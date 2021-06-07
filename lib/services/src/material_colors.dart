import 'package:flutter/material.dart';

class MaterialColors {
  static final MaterialColors _singleton = MaterialColors._internal();
  factory MaterialColors() => _singleton;
  MaterialColors._internal();

  final List<int> materialColorValues = <int>[
    Colors.grey.value,
    Colors.indigo.value,
    Colors.brown.value,
    Colors.deepOrange.value,
    Colors.yellow.value,
    Colors.green.value,
    Colors.lightBlue.value,
    Colors.purple.value,
    Colors.pink.value,
    Colors.red.value,
    //
    Colors.deepPurple.value,
    Colors.indigo.value,
    Colors.blue.value,
    Colors.cyan.value,
    Colors.lightGreen.value,
    Colors.lime.value,
    Colors.amber.value,
    Colors.orange.value,
    Colors.blueGrey.value,
  ];

  final List<String> materialColorNames = <String>[
    "Default",
    "Indigo",
    "Brown",
    "Orange",
    "Yellow",
    "Green",
    "Blue",
    "Purple",
    "Pink",
    "Red",
  ];
}
