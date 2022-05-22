import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'database_state.dart';

class DatabaseCubit extends HydratedCubit<DatabaseState> {
  DatabaseCubit() : super(const DatabaseState(tags: <String, int>{}));

  // void updateSortBy(int value) {
  //   emit(state.copyWith(sortby: value));
  // }

  // void updateCompactTags(bool value) =>
  //     emit(state.copyWith(compactTags: value));

  @override
  DatabaseState? fromJson(Map<String, dynamic> json) {
    return DatabaseState(
      isBiometricEnabled: json['isBiometricEnabled'] as bool,
      isPasscodeEnabled: json['isPasscodeEnabled'] as bool,
      passcode: json['passcode'] as String,
      tags: json['tags'] as Map<String, int>,
    );
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Map<String, dynamic> toJson(DatabaseState value) => <String, dynamic>{
        'isBiometricEnabled': value.isBiometricEnabled,
        'isPasscodeEnabled': value.isPasscodeEnabled,
        'passcode': value.passcode,
        'tags': value.tags,
      };
}
