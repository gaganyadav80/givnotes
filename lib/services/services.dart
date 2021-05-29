export 'src/initializers.dart';
export 'src/lockscreen_util.dart';
export 'src/permissions.dart';
export 'src/simple_bloc_observer.dart';
export 'src/disable_scrollglow.dart';
export 'src/cache.dart';
export 'src/multi_select_notes.dart';
export 'src/string_process.dart';

import 'package:givnotes/global/variables.dart';

extension StringEncryptExtension on String {
  String get encrypt => this.isEmpty ? "" : encrypter.encrypt(this, iv: iv).base64;

  String get decrypt => this.isEmpty ? "" : encrypter.decrypt64(this, iv: iv);
}