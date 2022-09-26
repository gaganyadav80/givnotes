import 'package:get/get.dart';

import 'prefs_controller.dart';

class TagSearchController extends GetxController {
  List<String> tagSearchList = <String>[];
  List<String> selectedTagList = <String>[];

  void resetSearchList() {
    tagSearchList
      ..clear()
      ..addAll(PrefsController.to.tags.keys.toList());

    update(['tagSearchList']);
  }

  void clearSearchListNOUP() => tagSearchList.clear();

  void addAllSearchList(List<String> value) {
    tagSearchList
      ..clear()
      ..addAll(value);
    update(['tagSearchList']);
  }

  void addSelectedList(String value) {
    selectedTagList.add(value);
    update(['selectedTagList']);
  }

  void removeSelectedList(String? value) {
    selectedTagList.remove(value);
    update(['selectedTagList']);
  }
}
