import 'package:givnotes/database/HiveDB.dart';
import 'package:package_info/package_info.dart';
import 'package:encrypt/encrypt.dart' as aes;

enum NoteMode { Adding, Editing }

class VariableService {
  static final VariableService _singleton = VariableService._internal();
  factory VariableService() => _singleton;
  VariableService._internal() {
    _randomUserProfile = 0;
    _isPermanentDisabled = false;
  }

  PrefsModel _prefsBox;
  PrefsModel get prefsBox => this._prefsBox;
  set prefsBox(PrefsModel value) => this._prefsBox = value;

  PackageInfo _packageInfo;
  PackageInfo get packageInfo => this._packageInfo;
  set packageInfo(PackageInfo value) => this._packageInfo = value;

  /// To check if storage permission is permanetly disabled
  bool _isPermanentDisabled;
  bool get isPermanentDisabled => this._isPermanentDisabled;
  set isPermanentDisabled(bool value) => this._isPermanentDisabled = value;

  /// Random int to use dummy profile pic
  int _randomUserProfile;
  int get randomUserProfile => this._randomUserProfile;
  set randomUserProfile(int value) => this._randomUserProfile = value;

  /// Length should be between `0 to 16` or `[0, 16]` (excluding 16). Else gives RangeError.
  aes.IV _iv;
  aes.IV get iv => this._iv;
  set iv(aes.IV value) => this._iv = value;

  /// base64 encoded key. If need to use a key for something else use `encryptionKey`.
  ///
  /// To get the UTF-8 string do `utf8.decode(base64.decode(encryptionKey))`.
  String _encryptionKey;
  String get encryptionKey => this._encryptionKey;
  set encryptionKey(String value) => this._encryptionKey = value;

  /// Use string extension under services to encrypt a String.
  aes.Encrypter _encrypter;
  aes.Encrypter get encrypter => this._encrypter;
  set encrypter(aes.Encrypter value) => this._encrypter = value;

  final List<String> _sortbyNames = ["Creation Date", "Modification Date", "Alphabetical (A-Z)", "Alphabetical (Z-A)"];
  List<String> get sortbyNames => this._sortbyNames;
}
