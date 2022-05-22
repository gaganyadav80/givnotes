// ignore_for_file: constant_identifier_names

import 'package:get_storage/get_storage.dart';
import 'package:givnotes/services/services.dart';

class Database {
  static final Database _database = Database._internal();
  factory Database() => _database;
  Database._internal();

  static late GetStorage getStorage;

  static bool get biometric => getStorage.read(KEY_BIOMETRIC_ENABLED) ?? false;
  static void updateBiometric(bool value) async =>
      await getStorage.write(KEY_BIOMETRIC_ENABLED, value);

  static String get passcode =>
      ((getStorage.read(KEY_PASSCODE) ?? "") as String).decrypt;

  static void updatePasscode(String value) async {
    String encryptedPass = value.encrypt;
    await getStorage.write(KEY_PASSCODE, encryptedPass);

    if (value.isNotEmpty) {
      await getStorage.write(KEY_PASSCODE_ENABLED, true);
    } else {
      await getStorage.write(KEY_PASSCODE_ENABLED, false);
    }
  }

  static bool get passcodeEnabled =>
      getStorage.read(KEY_PASSCODE_ENABLED) ?? false;

  static Map<String, int> get tags =>
      Map<String, int>.from((getStorage.read(KEY_TAGS_MAP) ?? {}) as Map);

  static void updateTags(Map<String, int> value) async =>
      await getStorage.write(KEY_TAGS_MAP, value);

  static const String dbName = 'HiveDB.db';
  static const String KEY_BIOMETRIC_ENABLED = 'KEY_BIOMETRIC_ENABLED';
  static const String KEY_PASSCODE = 'KEY_PASSCODE';
  static const String KEY_PASSCODE_ENABLED = 'KEY_PASSCODE_ENABLED';
  static const String KEY_TAGS_MAP = 'KEY_TAGS_MAP';
}
