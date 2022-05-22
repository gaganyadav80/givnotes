import 'dart:convert';

import 'package:get/get.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/screens/src/notes/src/notes_repository.dart';

class PrefsController extends GetxController {
  static PrefsController get to => Get.find();

  @override
  void onInit() {
    fromJson(Database.prefsJson);
    super.onInit();
  }

  final RxInt homeSelectedIndex = RxInt(0);

  /// 0: created, 1: modified, 2: a-z, 3: z-a
  final RxInt sortBy = RxInt(0);
  final RxBool compactTags = RxBool(false);

  void setHomeIndex(int index) {
    homeSelectedIndex.value = index;
  }

  void persist() {
    Database.updatePrefsJson(toJson());
  }

  void setSortBy(int value) {
    if (value < 0 || value > 3) {
      return;
    } else {
      sortBy.value = value;
      persist();
      Get.find<NotesController>().sortby = value;
    }
  }

  void setCompactTags(bool value) {
    compactTags.value = value;
    persist();
  }

  Map<String, dynamic> toMap() {
    return {
      'sortBy': sortBy.value,
      'compactTags': compactTags.value,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    sortBy.value = map['sortBy'] as int;
    compactTags.value = map['compactTags'] as bool;
  }

  String toJson() => json.encode(toMap());

  void fromJson(String source) => fromMap(json.decode(source));
}
