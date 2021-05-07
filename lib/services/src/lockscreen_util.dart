import 'package:flutter/material.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/widgets/simple_lockscreen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class ShowLockscreen extends StatefulWidget {
  ShowLockscreen({
    Key key,
    @required this.changePassAuth,
    this.disableLock = false,
  }) : super(key: key);

  final bool changePassAuth;
  final bool disableLock;

  @override
  _ShowLockscreenState createState() => new _ShowLockscreenState();
}

class _ShowLockscreenState extends State<ShowLockscreen> {
  Future<bool> biometrics(BuildContext context) async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        // localizedReason: 'Authenticate to unlock givnotes',
        biometricOnly: true,
        localizedReason: '',
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      print("Error: $e");
    }
    if (!mounted) return false;
    if (authenticated) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleLockScreen(
      title: 'Unlock givnotes',
      correctString: prefsBox.passcode,
      confirmMode: false,
      canCancel: widget.changePassAuth || widget.disableLock,
      canBiometric: prefsBox.biometric,
      showBiometricFirst: prefsBox.biometric,
      biometricAuthenticate: biometrics,
      onUnlocked: widget.changePassAuth
          ? () {
              Navigator.of(context)
                ..pop()
                ..pushNamed(RouterName.addlockRoute); //TODO disrupts the view with zoom effect. FIX @Gagan
            }
          : () {
              AppLock.of(context).didUnlock();
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

class AddLockscreen extends StatefulWidget {
  const AddLockscreen({Key key}) : super(key: key);

  @override
  _AddLockscreenState createState() => _AddLockscreenState();
}

class _AddLockscreenState extends State<AddLockscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SimpleLockScreen(
        title: 'Lock givnotes',
        confirmMode: true,
        canCancel: true,
        canBiometric: false,
        isAddingLock: true,
        onCompleted: (context, passcode) {
          prefsBox.passcode = passcode;
          AppLock.of(context).enable();
          prefsBox.applock = true;
          prefsBox.save();

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
      ),
    );
  }
}
