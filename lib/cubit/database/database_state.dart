part of 'database_cubit.dart';

class DatabaseState extends Equatable {
  const DatabaseState({
    this.isBiometricEnabled = false,
    this.isPasscodeEnabled = false,
    this.passcode = "",
    this.tags,
  });

  final bool? isBiometricEnabled;
  final bool? isPasscodeEnabled;
  final String? passcode;
  final Map<String, int>? tags;

  @override
  List<Object?> get props =>
      [isBiometricEnabled, isPasscodeEnabled, passcode, tags];

  DatabaseState copyWith({
    bool? isBiometricEnabled,
    bool? isPasscodeEnabled,
    String? passcode,
    Map<String, int>? tags,
  }) {
    return DatabaseState(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isPasscodeEnabled: isPasscodeEnabled ?? this.isPasscodeEnabled,
      passcode: passcode ?? this.passcode,
      tags: tags ?? this.tags,
    );
  }
}
