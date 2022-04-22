import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givnotes/database/database.dart';
import 'package:local_auth/local_auth.dart';

import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/widgets/simple_lockscreen.dart';

class ShowLockscreen extends StatelessWidget {
  const ShowLockscreen({
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
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false,
        ),
      );
    } on PlatformException catch (e) {
      log("Error: $e");
    }
    // if (!mounted) return false;
    if (authenticated) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleLockScreen(
      title: 'Unlock givnotes',
      simpleTitle: 'Re-enter your \nPIN',
      correctString: Database.passcode,
      confirmMode: false,
      canCancel: changePassAuth != null ? true : false,
      canBiometric: changePassAuth != null ? true : Database.biometric,
      showBiometricFirst: Database.biometric,
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
        Database.updatePasscode(passcode);
        AppLock.of(context)!.enable();
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
