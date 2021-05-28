import 'package:givnotes/database/HiveDB.dart';
import 'package:package_info/package_info.dart';
import 'package:encrypt/encrypt.dart' as aes;

//TODO maybe use class or more secure way to keep encryptionKey global
PrefsModel prefsBox;
PackageInfo packageInfo;
bool isPermanentDisabled = true;
// aes.Key key;
aes.IV iv = aes.IV.fromLength(16);
aes.Encrypter encrypter;
String encryptionKey; //global to use with hive or maybe somewhere else

int randomUserProfile = 0;

const List<String> sortbyNames = ["Creation Date", "Modification Date", "Alphabetical (A-Z)", "Alphabetical (Z-A)"];

enum NoteMode { Adding, Editing }