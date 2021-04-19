import 'package:givnotes/database/database.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

Future<void> initHiveDb() async {
  await Hive.initFlutter();
  Hive.registerAdapter<NotesModel>(NotesModelAdapter());
  Hive.registerAdapter<PrefsModel>(PrefsModelAdapter());

  Box<PrefsModel> box = await Hive.openBox<PrefsModel>('prefs');
  await Hive.openBox<NotesModel>('givnotes');

  if (box.isEmpty) {
    await box.add(PrefsModel());
  }
  prefsBox = box.values.first;
}

Future<void> pluginInitializer() async {
  packageInfo = await PackageInfo.fromPlatform();

  PrefService.init(prefix: 'pref_');
}
