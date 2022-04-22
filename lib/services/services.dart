import 'dart:convert';

import 'src/variables.dart';

export 'src/cache.dart';
export 'src/disable_scrollglow.dart';
export 'src/initializers.dart';
export 'src/lockscreen_util.dart';
export 'src/material_colors.dart';
export 'src/multi_select_notes.dart';
export 'src/permissions.dart';
export 'src/simple_bloc_observer.dart';
export 'src/string_process.dart';
export 'src/utils.dart';
export 'src/validators.dart';
export 'src/variables.dart';

extension StringEncryptExtension on String {
  String get encrypt => isEmpty
      ? ""
      : VariableService()
          .encrypter
          .encrypt(this, iv: VariableService().iv)
          .base64;

  String get decrypt => isEmpty
      ? ""
      : VariableService().encrypter.decrypt64(this, iv: VariableService().iv);

  String get stringToBase64 => base64Encode(utf8.encode(this));
}
