import 'dart:convert';
import 'dart:math';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:encrypt/encrypt.dart' as aes;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/services/services.dart';

Future<void> initGetXControllers() async {
  Get.put(TagSearchController());
  Get.put(MultiSelectController());
}

Future<void> initHiveDb() async {
  await Hive.initFlutter();
  Hive.registerAdapter<NotesModel>(NotesModelAdapter());
  Hive.registerAdapter<PrefsModel>(PrefsModelAdapter());

  final Box<PrefsModel> box = await Hive.openBox<PrefsModel>(
    'prefs',
    encryptionCipher: HiveAesCipher(base64Url.decode(encryptionKey)),
  );
  await Hive.openBox<NotesModel>('givnotes', encryptionCipher: HiveAesCipher(base64Url.decode(encryptionKey)));

  if (box.isEmpty) {
    await box.add(PrefsModel());
  }
  prefsBox = box.values.first;
}

Future<void> pluginInitializer() async {
  packageInfo = await PackageInfo.fromPlatform();
  PrefService.init(prefix: 'pref_');

  final BiometricStorageFile secureStorage = await BiometricStorage().getStorage(
    'key',
    options: StorageFileInitOptions(authenticationRequired: false),
  );
  final containsEncryptionKey = await secureStorage.read();

  if (containsEncryptionKey == null) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(base64Encode(key));
  }

  encryptionKey = await secureStorage.read();

  aes.Key key = aes.Key.fromBase64(encryptionKey);
  encrypter = aes.Encrypter(aes.AES(key));

  // Random int to use dummy profile pic
  randomUserProfile = Random().nextInt(21) + 1;
}
