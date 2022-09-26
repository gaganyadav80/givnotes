import 'dart:math';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:encrypt/encrypt.dart' as aes;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/database/db_helper.dart';

import 'package:givnotes/services/services.dart';

void initGetXControllers() {
  DBHelper.getStorage = GetStorage(DBHelper.dbName);
  VariableService(); // maybe use as getxcontroller

  Get.put(AuthController());
  Get.put(PrefsController());
  Get.put(TagSearchController());
  Get.put(MultiSelectController());
  Get.put(NotesController());
  Get.put(TodoDateController());
  Get.put(NoteStatusController());
}

Future<bool> pluginInitializer(String userID, {String? userKey}) async {
  // PrefService.init(prefix: 'pref_');

  //TODO clear the storage on logout and then no need to use separate storage for each user account on the device.

  // final BiometricStorageFile secureStorage = await BiometricStorage().getStorage(
  //   '$userID:key:iv',
  //   options: StorageFileInitOptions(authenticationRequired: false),
  // );

  // String? storageContent = await secureStorage.read();
  String storageContent = await DBHelper.userKey(userID);

  if (userKey == null && storageContent.isEmpty) {
    return false;
  }

  if (storageContent.isEmpty || storageContent.split(':')[0] != userID) {
    // Not required to make it 32 byte. Was required for hive db.
    if (userKey!.length < 32) {
      userKey += 'X#P%5vu!w2zTPm&1#n0%zz^38^'.substring(0, 32 - userKey.length);
    }

    // Gives RangeError if length >= 16
    aes.IV tempIV = aes.IV.fromUtf8(userKey.substring(0, 16));
    // await secureStorage.write("$userID:${userKey.stringToBase64}:${tempIV.base64}");
    // print("+++++++++++ RE-READ ${await secureStorage.read()}");
    final newUserKey = "$userID:${userKey.stringToBase64}:${tempIV.base64}";
    await DBHelper.updateUserKey(userID, newUserKey);
    storageContent = newUserKey;
  }

  VariableService().encryptionKey = storageContent.split(':')[1];
  VariableService().iv = aes.IV.fromBase64(storageContent.split(':')[2]);

  aes.Key key = aes.Key.fromBase64(VariableService().encryptionKey);
  VariableService().encrypter = aes.Encrypter(aes.AES(key));

  // Extra initializations after User Login
  VariableService().randomUserProfile = Random().nextInt(21);

  return true;
}
