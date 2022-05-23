import 'dart:convert';

import 'package:get/get.dart';
import 'package:givnotes/database/db_helper.dart';
import 'notes_controller.dart';

class PrefsController extends GetxController {
  static PrefsController get to => Get.find();

  @override
  void onInit() {
    fromJson(DBHelper.prefsJson);
    super.onInit();
  }

  final RxInt homeSelectedIndex = RxInt(0);

  /// 0: created, 1: modified, 2: a-z, 3: z-a
  final RxInt sortBy = RxInt(0);
  final RxBool compactTags = RxBool(false);
  final RxBool biometricEnabled = RxBool(false);
  final RxString passcode = RxString("");
  final RxBool passcodeEnabled = RxBool(false);
  final RxMap<String, int> tags = RxMap<String, int>({});

  void setHomeIndex(int index) {
    homeSelectedIndex.value = index;
  }

  void persist() {
    DBHelper.updatePrefsJson(toJson());
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

  void setBiometricEnabled(bool value) {
    biometricEnabled.value = value;
    persist();
  }

  void setPasscode(String value) {
    passcode.value = value;
    if (value.isNotEmpty) {
      passcodeEnabled.value = true;
    } else {
      passcodeEnabled.value = false;
    }
    persist();
  }

  void setTagsMap(Map<String, int> value) {
    tags.value = value;
    persist();
  }

  Map<String, dynamic> toMap() {
    return {
      'sortBy': sortBy.value,
      'compactTags': compactTags.value,
      'biometricEnabled': biometricEnabled.value,
      'passcode': passcode
          .value, //TODO can encrypt but can't decrypt because the init of this controller will be called before authentication
      'passcodeEnabled': passcodeEnabled.value,
      'tags': tags,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    sortBy.value = map['sortBy'] as int;
    compactTags.value = map['compactTags'] as bool;
    biometricEnabled.value = map['biometricEnabled'] as bool;
    passcode.value = map['passcode'] as String;
    passcodeEnabled.value = map['passcodeEnabled'] as bool;
    tags.value = map['tags'] as Map<String, int>;
  }

  String toJson() => json.encode(toMap());

  void fromJson(String source) => fromMap(json.decode(source));
}
