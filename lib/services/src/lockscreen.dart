import 'package:flutter/material.dart';
import 'package:givnotes/global/variables.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowLockscreen extends StatefulWidget {
  ShowLockscreen({
    Key key,
    @required this.changePassAuth,
  }) : super(key: key);

  final bool changePassAuth;

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
    return LockScreen(
      title: 'Enter Passcode',
      correctString: prefsBox.passcode,
      confirmMode: false,
      digits: 4,
      canCancel: widget.changePassAuth,
      canBiometric: prefsBox.biometric,
      showBiometricFirst: prefsBox.biometric,
      biometricAuthenticate: biometrics,
      backgroundColorOpacity: 1,
      onUnlocked: widget.changePassAuth
          ? () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RouterName.addlockRoute);
            }
          : () {
              AppLock.of(context).didUnlock();
            },
      dotSecretConfig: DotSecretConfig(
        dotSize: 15.w,
        dotBorderColor: Colors.teal[200],
        enabledColor: Colors.teal[100],
        padding: EdgeInsets.symmetric(horizontal: 75.w, vertical: 0),
      ),
      circleInputButtonConfig: CircleInputButtonConfig(
        backgroundColor: Colors.teal[200],
      ),
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
      body: LockScreen(
        title: 'Enter New Passcode',
        confirmMode: true,
        canCancel: true,
        canBiometric: false,
        backgroundColorOpacity: 0,
        onCompleted: (context, passcode) {
          prefsBox.passcode = passcode;
          AppLock.of(context).enable();
          prefsBox.applock = true;
          prefsBox.save();
          // Navigator.push(
          //   context,
          //   MorpheusPageRoute(builder: (context) => HomePage()),
          // );
          Navigator.pop(context, true);
          passChangeAlert(context);
        },
        dotSecretConfig: DotSecretConfig(
          dotSize: 15.w,
          dotBorderColor: Colors.teal[200],
          enabledColor: Colors.teal[100],
          padding: EdgeInsets.symmetric(horizontal: 75.w, vertical: 0),
        ),
        circleInputButtonConfig: CircleInputButtonConfig(
          backgroundColor: Colors.teal[200],
        ),
      ),
    );
  }
}

passChangeAlert(BuildContext context) {
  Future.delayed(Duration(milliseconds: 500), () async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Passcode changed successfully!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  });
}
