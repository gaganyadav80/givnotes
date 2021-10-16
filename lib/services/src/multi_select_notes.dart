import 'package:get/get.dart';

class MultiSelectController extends GetxController {
  final RxList<String> selectedIndexes = <String>[].obs;
  bool isSelecting = false;

  Future<void> select(String n) async {
    if (selectedIndexes.contains(n)) {
      selectedIndexes.remove(n);
    } else {
      selectedIndexes.add(n);
    }

    if (selectedIndexes.isEmpty) {
      isSelecting = false;
    } else {
      isSelecting = true;
    }
  }

  void clearSelectedList() {
    selectedIndexes.clear();
  }

  bool isSelected(String n) => selectedIndexes.contains(n);

  int get selectedLength => selectedIndexes.length;
}
