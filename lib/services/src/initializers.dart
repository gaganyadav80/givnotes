import 'dart:math';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:encrypt/encrypt.dart' as aes;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

import 'package:givnotes/database/database.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/src/notes/src/notes_repository.dart';
import 'package:givnotes/services/services.dart';

Future<void> initGetXControllers() async {
  Get.put(TagSearchController());
  Get.put(MultiSelectController());
  Get.put(NotesController());
}

Future<void> initHiveDb() async {
  await Hive.initFlutter();
  // Hive.registerAdapter<NotesModel>(NotesModelAdapter());
  Hive.registerAdapter<PrefsModel>(PrefsModelAdapter());

  // encryptionCipher: HiveAesCipher(base64.decode(encryptionKey)),
  final Box<PrefsModel> box = await Hive.openBox<PrefsModel>('prefs');
  // await Hive.openBox<NotesModel>('givnotes');

  if (box.isEmpty) {
    await box.add(PrefsModel());
  }
  VariableService().prefsBox = box.values.first;
}

Future<dynamic> pluginInitializer(String userID, {String userKey}) async {
  VariableService().packageInfo = await PackageInfo.fromPlatform();
  PrefService.init(prefix: 'pref_');

  final BiometricStorageFile secureStorage = await BiometricStorage().getStorage(
    'key:iv',
    options: StorageFileInitOptions(authenticationRequired: false),
  );

  String storageContent = await secureStorage.read();

  if (storageContent == null || storageContent.isEmpty || storageContent.split(':')[0] != userID) {
    // Not required to make it 32 byte
    if (userKey.length < 32) {
      userKey += 'X#P%5vu!w2zTPm&1#n0%zz^38^'.substring(0, 32 - userKey.length);
    }

    // Gives RangeError if length >= 16
    aes.IV tempIV = aes.IV.fromUtf8(userKey.substring(0, 16));
    await secureStorage.write("$userID:${userKey.stringToBase64}:${tempIV.base64}");
    storageContent = await secureStorage.read();
  }

  VariableService().encryptionKey = storageContent.split(':')[1];
  VariableService().iv = aes.IV.fromBase64(storageContent.split(':')[2]);

  aes.Key key = aes.Key.fromBase64(VariableService().encryptionKey);
  VariableService().encrypter = aes.Encrypter(aes.AES(key));

  VariableService().randomUserProfile = Random().nextInt(21);
}
