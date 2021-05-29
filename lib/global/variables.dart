import 'package:givnotes/database/HiveDB.dart';
import 'package:package_info/package_info.dart';
import 'package:encrypt/encrypt.dart' as aes;

//TODO maybe use class or more secure way to keep encryptionKey global
PrefsModel prefsBox;
PackageInfo packageInfo;
/// To check if storage permission is permanetly disabled
bool isPermanentDisabled = true;
/// Random int to use dummy profile pic
int randomUserProfile = 0;

// encryption variables
aes.IV iv;
/// base64 encoded key. If need to use a key for something else use `encryptionKey`.
/// 
/// Practical use case is `convert.base64.decode(encryptionKey)`.
String encryptionKey;
/// Use string extension under services to encrypt a String.
aes.Encrypter encrypter;


const List<String> sortbyNames = ["Creation Date", "Modification Date", "Alphabetical (A-Z)", "Alphabetical (Z-A)"];

enum NoteMode { Adding, Editing }