import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/simple_lockscreen.dart';

class ShowLockscreen extends StatelessWidget {
  ShowLockscreen({
    Key? key,
    required this.changePassAuth,
  }) : super(key: key);

  final VoidCallback? changePassAuth;

  Future<bool> biometrics(BuildContext context) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to unlock givnotes',
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      print("Error: $e");
    }
    // if (!mounted) return false;
    if (authenticated) {
      return true;
    }
    return false;
  }

  final VariableService _variableService = VariableService();

  @override
  Widget build(BuildContext context) {
    return SimpleLockScreen(
      title: 'Unlock givnotes',
      simpleTitle: 'Re-enter your \nPIN',
      correctString: _variableService.prefsBox.passcode,
      confirmMode: false,
      canCancel: changePassAuth != null ? true : false,
      canBiometric:
          changePassAuth != null ? true : _variableService.prefsBox.biometric,
      showBiometricFirst: _variableService.prefsBox.biometric,
      biometricAuthenticate: biometrics,
      onUnlocked: changePassAuth ??
          () {
            AppLock.of(context)!.didUnlock();
          },
      // dotSecretConfig: DotSecretConfig(
      //   dotSize: 15.w,
      //   dotBorderColor: Color(0xffDD4C4F),
      //   enabledColor: Color(0xffDD4C4F),
      //   padding: EdgeInsets.symmetric(horizontal: 75.w, vertical: 0),
      // ),
      // circleInputButtonConfig: CircleInputButtonConfig(
      //   backgroundColor: Color(0xffDD4C4F),
      // ),
    );
  }
}

class AddLockscreen extends StatelessWidget {
  const AddLockscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleLockScreen(
      simpleTitle: 'Enter your new\nPIN',
      simpleConfirmTitle: 'Confirm your \nPIN',
      confirmMode: true,
      canCancel: true,
      canBiometric: false,
      isAddingLock: true,
      onCompleted: (ctx, passcode) {
        VariableService().prefsBox.passcode = passcode;
        AppLock.of(context)!.enable();
        VariableService().prefsBox.save();
        Navigator.pop(context, true);
      },
      // dotSecretConfig: DotSecretConfig(
      //   dotSize: 15.w,
      //   dotBorderColor: Color(0xffDD4C4F),
      //   enabledColor: Color(0xffDD4C4F),
      //   padding: EdgeInsets.symmetric(horizontal: 75.w, vertical: 0),
      // ),
      // circleInputButtonConfig: CircleInputButtonConfig(
      //   backgroundColor: Color(0xffDD4C4F),
      //   backgroundOpacity: 0.6,
      // ),
    );
  }
}
