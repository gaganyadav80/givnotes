import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectMultiNotes extends GetxController {
  var selectedIndexes = [].obs;
  Future<void> selected({@required int n}) async {
    if (selectedIndexes.contains(n)) {
      selectedIndexes.remove(n);
    } else {
      selectedIndexes.add(n);
    }
  }

  void clearSelectedList() {
    selectedIndexes.clear();
  }
}
