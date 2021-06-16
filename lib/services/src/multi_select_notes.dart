import 'package:get/get.dart';

class MultiSelectController extends GetxController {
  final RxList<String> selectedIndexes = <String>[].obs;
  bool isSelecting = false;

  Future<void> select(String n) async {
    if (this.selectedIndexes.contains(n)) {
      this.selectedIndexes.remove(n);
    } else {
      this.selectedIndexes.add(n);
    }

    if (this.selectedIndexes.isEmpty) {
      this.isSelecting = false;
    } else {
      this.isSelecting = true;
    }
  }

  void clearSelectedList() {
    this.selectedIndexes.clear();
  }

  bool isSelected(String n) => this.selectedIndexes.contains(n); 

  int get selectedLength => this.selectedIndexes.length;
}
