import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:givnotes/enums/prefs.dart';
import 'package:givnotes/packages/lock_screen/dot_secret_ui.dart';
import 'package:givnotes/packages/lock_screen/lock_screen.dart';
import 'package:givnotes/packages/lock_screen/circle_input_button.dart';
import 'package:givnotes/pages/home.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:morpheus/morpheus.dart';
import 'package:route_transitions/route_transitions.dart';

class Lockscreen extends StatefulWidget {
  Lockscreen({
    Key key,
    @required this.changePassAuth,
  }) : super(key: key);

  final bool changePassAuth;

  @override
  _LockscreenState createState() => new _LockscreenState();
}

class _LockscreenState extends State<Lockscreen> {
  Future<bool> biometrics(BuildContext context) async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
        // localizedReason: 'Authenticate to unlock givnotes',
        localizedReason: '',
        useErrorDialogs: true,
        stickyAuth: false,
      );
    } on PlatformException catch (e) {
      errorAlert(context, e);
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
      correctString: prefsBox.get('passcode'),
      confirmMode: false,
      digits: 4,
      canCancel: widget.changePassAuth,
      canBiometric: prefsBox.get('biometric') ?? false,
      showBiometricFirst: prefsBox.get('biometric') ?? true,
      biometricAuthenticate: biometrics,
      backgroundColorOpacity: 1,
      onUnlocked: widget.changePassAuth
          ? () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteTransition(
                  builder: (context) => AddLockscreen(),
                  animationType: AnimationType.slide_right,
                  curves: Curves.easeOut,
                ),
              );
            }
          : () {
              AppLock.of(context).didUnlock();
            },
      dotSecretConfig: DotSecretConfig(
        dotSize: 15,
        dotBorderColor: Colors.teal[200],
        enabledColor: Colors.teal[100],
        padding: EdgeInsets.symmetric(horizontal: 75, vertical: 0),
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
          prefsBox.put('passcode', passcode);
          AppLock.of(context).enable();
          prefsBox.put('applock', true);
          Navigator.push(context, MorpheusPageRoute(builder: (context) => HomePage()));
          passChangeAlert(context);
        },
        dotSecretConfig: DotSecretConfig(
          dotSize: 15,
          dotBorderColor: Colors.teal[200],
          enabledColor: Colors.teal[100],
          padding: EdgeInsets.symmetric(horizontal: 75, vertical: 0),
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
