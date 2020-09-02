import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_screen_lock/lock_screen.dart';
import 'package:givnotes/enums/prefs.dart';
import 'package:givnotes/utils/home.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/morpheus.dart';
import 'package:route_transitions/route_transitions.dart';

class Lockscreen extends StatefulWidget {
  Lockscreen({Key key, @required this.changePassAuth}) : super(key: key);

  final bool changePassAuth;

  @override
  _LockscreenState createState() => new _LockscreenState();
}

class _LockscreenState extends State<Lockscreen> {
  // bool isFingerprint = false;

  Future<bool> biometrics(BuildContext context) async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
        localizedReason: 'Authenticate to unlock givnotes',
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      errorAlert(context, e);
    }
    if (!mounted) return false;
    if (authenticated) {
      return true;
      // setState(() {
      //   isFingerprint = true;
      // });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LockScreen(
      title: 'Enter your passcode',
      correctString: prefsBox.get('passcode'),
      confirmMode: false,
      canCancel: false,
      canBiometric: prefsBox.get('biometric') ?? false,
      showBiometricFirst: true,
      biometricAuthenticate: biometrics,
      backgroundColorOpacity: 1,
      // onCompleted: (context, _) => AppLock.of(context).didUnlock(),
      onUnlocked: () => widget.changePassAuth
          ? Navigator.push(
              context,
              PageRouteTransition(
                builder: (context) => AddLockscreen(),
                animationType: AnimationType.slide_right,
              ),
            )
          : AppLock.of(context).didUnlock(),
    );
  }
}

class AddLockscreen extends StatelessWidget {
  const AddLockscreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LockScreen(
        title: 'Enter new passcode',
        confirmMode: true,
        canCancel: true,
        canBiometric: false,
        backgroundColorOpacity: 0,
        onCompleted: (context, passcode) {
          prefsBox.put('passcode', passcode);
          AppLock.of(context).enable();
          prefsBox.put('applock', true);
          Navigator.push(context, MorpheusPageRoute(builder: (context) => HomePage()));
          passChangeAlert(context);
        },
      ),
    );
  }
}

passChangeAlert(BuildContext context) {
  Future.delayed(Duration(milliseconds: 1000), () async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Passcode changed successfully!'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  });
}
