import 'package:givnotes/database/HiveDB.dart';
import 'package:package_info/package_info.dart';
import 'package:encrypt/encrypt.dart' as aes;

enum NoteMode { adding, editing }

class VariableService {
  static final VariableService _singleton = VariableService._internal();
  factory VariableService() => _singleton;
  VariableService._internal() {
    randomUserProfile = 0;
    isPermanentDisabled = false;
    PackageInfo.fromPlatform().then((value) => packageInfo = value);
  }

  late PrefsModel prefsBox;
  // PrefsModel get prefsBox => _prefsBox;
  // set prefsBox(PrefsModel value) => _prefsBox = value;

  late PackageInfo packageInfo;
  // PackageInfo get packageInfo => _packageInfo;
  // set packageInfo(PackageInfo value) => _packageInfo = value;

  /// To check if storage permission is permanetly disabled
  late bool isPermanentDisabled;
  // bool get isPermanentDisabled => _isPermanentDisabled;
  // set isPermanentDisabled(bool value) => _isPermanentDisabled = value;

  /// Random int to use dummy profile pic
  int? randomUserProfile;
  // int get randomUserProfile => _randomUserProfile;
  // set randomUserProfile(int value) => _randomUserProfile = value;

  /// Length should be between `0 to 16` or `[0, 16]` (excluding 16). Else gives RangeError.
  aes.IV? iv;
  // aes.IV get iv => _iv;
  // set iv(aes.IV value) => _iv = value;

  /// base64 encoded key. If need to use a key for something else use `encryptionKey`.
  ///
  /// To get the UTF-8 string do `utf8.decode(base64.decode(encryptionKey))`.
  late String encryptionKey;
  // String get encryptionKey => _encryptionKey;
  // set encryptionKey(String value) => _encryptionKey = value;

  /// Use string extension under services to encrypt a String.
  late aes.Encrypter encrypter;
  // aes.Encrypter get encrypter => _encrypter;
  // set encrypter(aes.Encrypter value) => _encrypter = value;

  final List<String> _sortbyNames = [
    "Creation Date",
    "Modification Date",
    "Alphabetical (A-Z)",
    "Alphabetical (Z-A)"
  ];
  List<String> get sortbyNames => _sortbyNames;
}
