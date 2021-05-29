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
    encryptionCipher: HiveAesCipher(base64.decode(encryptionKey)),
  );
  await Hive.openBox<NotesModel>('givnotes', encryptionCipher: HiveAesCipher(base64.decode(encryptionKey)));

  if (box.isEmpty) {
    await box.add(PrefsModel());
  }
  prefsBox = box.values.first;
}

Future<void> pluginInitializer() async {
  packageInfo = await PackageInfo.fromPlatform();
  PrefService.init(prefix: 'pref_');

  final BiometricStorageFile secureStorage = await BiometricStorage().getStorage(
    'key:iv',
    options: StorageFileInitOptions(authenticationRequired: false),
  );
  final containsEncryptionKey = await secureStorage.read();

  if (containsEncryptionKey == null) {
    var key = Hive.generateSecureKey();
    aes.IV tempIV = aes.IV.fromSecureRandom(16);
    await secureStorage.write("${base64Encode(key)}:${tempIV.base64}");
  }

  String temp = await secureStorage.read();

  encryptionKey = temp.split(':')[0];
  iv = aes.IV.fromBase64(temp.split(':')[1]);

  aes.Key key = aes.Key.fromBase64(encryptionKey);
  encrypter = aes.Encrypter(aes.AES(key));

  randomUserProfile = Random().nextInt(21) + 1;
}
