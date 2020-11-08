import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:givnotes/packages/move_to_background.dart';
import 'dot_secret_ui.dart';
import 'circle_input_button.dart';

/// commented out all the Navigator.of(context).pop();
/// to make it work with AppLock package

// Future showConfirmPasscode({
//   @required BuildContext context,
//   String title = 'Please enter passcode.',
//   String confirmTitle = 'Please enter confirm passcode.',
//   String cancelText = 'Cancel',
//   String deleteText = 'Delete',
//   int digits = 4,
//   DotSecretConfig dotSecretConfig = const DotSecretConfig(),
//   void Function(BuildContext, String) onCompleted,
//   Color backgroundColor = Colors.white,
//   double backgroundColorOpacity = 0.5,
//   CircleInputButtonConfig circleInputButtonConfig = const CircleInputButtonConfig(),
// }) {
//   return Navigator.of(context).push(
//     PageRouteBuilder(
//       opaque: false,
//       pageBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secodaryAnimation,
//       ) {
//         return LockScreen(
//           title: title,
//           confirmTitle: confirmTitle,
//           confirmMode: true,
//           digits: digits,
//           dotSecretConfig: dotSecretConfig,
//           onCompleted: onCompleted,
//           cancelText: cancelText,
//           deleteText: deleteText,
//           backgroundColor: backgroundColor,
//           backgroundColorOpacity: backgroundColorOpacity,
//           circleInputButtonConfig: circleInputButtonConfig,
//         );
//       },
//       transitionsBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//         Widget child,
//       ) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0.0, 2.4),
//             end: Offset.zero,
//           ).animate(animation),
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset.zero,
//               end: const Offset(0.0, 2.4),
//             ).animate(secondaryAnimation),
//             child: child,
//           ),
//         );
//       },
//     ),
//   );
// }

// Future showLockScreen({
//   @required BuildContext context,
//   String correctString,
//   String title = 'Please enter passcode.',
//   String cancelText = 'Cancel',
//   String deleteText = 'Delete',
//   int digits = 4,
//   DotSecretConfig dotSecretConfig = const DotSecretConfig(),
//   bool canCancel = true,
//   void Function(BuildContext, String) onCompleted,
//   Widget biometricButton = const Icon(Icons.fingerprint),
//   bool canBiometric = false,
//   bool showBiometricFirst = false,
//   @Deprecated('use biometricAuthenticate.') void Function(BuildContext) biometricFunction,
//   Future<bool> Function(BuildContext) biometricAuthenticate,
//   Color backgroundColor = Colors.white,
//   double backgroundColorOpacity = 0.5,
//   CircleInputButtonConfig circleInputButtonConfig = const CircleInputButtonConfig(),
//   void Function() onUnlocked,
// }) {
//   return Navigator.of(context).push(
//     PageRouteBuilder(
//       opaque: false,
//       pageBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secodaryAnimation,
//       ) {
//         var _showBiometricFirstController = StreamController<void>();

//         animation.addStatusListener((status) {
//           // Calling the biometric on completion of the animation.
//           if (status == AnimationStatus.completed) {
//             _showBiometricFirstController.add(null);
//           }
//         });

//         return LockScreen(
//           correctString: correctString,
//           title: title,
//           digits: digits,
//           dotSecretConfig: dotSecretConfig,
//           onCompleted: onCompleted,
//           canCancel: canCancel,
//           cancelText: cancelText,
//           deleteText: deleteText,
//           biometricButton: biometricButton,
//           canBiometric: canBiometric,
//           showBiometricFirst: showBiometricFirst,
//           showBiometricFirstController: _showBiometricFirstController,
//           biometricFunction: biometricFunction,
//           biometricAuthenticate: biometricAuthenticate,
//           backgroundColor: backgroundColor,
//           backgroundColorOpacity: backgroundColorOpacity,
//           circleInputButtonConfig: circleInputButtonConfig,
//           onUnlocked: onUnlocked,
//         );
//       },
//       transitionsBuilder: (
//         BuildContext context,
//         Animation<double> animation,
//         Animation<double> secondaryAnimation,
//         Widget child,
//       ) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0.0, 2.4),
//             end: Offset.zero,
//           ).animate(animation),
//           child: SlideTransition(
//             position: Tween<Offset>(
//               begin: Offset.zero,
//               end: const Offset(0.0, 2.4),
//             ).animate(secondaryAnimation),
//             child: child,
//           ),
//         );
//       },
//     ),
//   );
// }

class LockScreen extends StatefulWidget {
  final String correctString;
  final String title;
  final String confirmTitle;
  final bool confirmMode;
  final Widget rightSideButton;
  final int digits;
  final DotSecretConfig dotSecretConfig;
  final CircleInputButtonConfig circleInputButtonConfig;
  final bool canCancel;
  final String cancelText;
  final String deleteText;
  final Widget biometricButton;
  final void Function(BuildContext, String) onCompleted;
  final bool canBiometric;
  final bool showBiometricFirst;
  // @Deprecated('use biometricAuthenticate.')
  // final void Function(BuildContext) biometricFunction;
  final Future<bool> Function(BuildContext) biometricAuthenticate;
  final StreamController<void> showBiometricFirstController;
  final Color backgroundColor;
  final double backgroundColorOpacity;
  final void Function() onUnlocked;

  LockScreen({
    this.correctString,
    this.title = 'Enter Passcode',
    this.confirmTitle = 'Enter Confirm Passcode',
    this.confirmMode = false,
    this.digits = 4,
    this.dotSecretConfig = const DotSecretConfig(),
    this.circleInputButtonConfig = const CircleInputButtonConfig(),
    this.rightSideButton,
    this.canCancel = true,
    this.cancelText = 'Cancel',
    this.deleteText = 'Delete',
    this.biometricButton = const Icon(Icons.fingerprint),
    this.onCompleted,
    this.canBiometric = false,
    this.showBiometricFirst = false,
    // this.biometricFunction,
    this.biometricAuthenticate,
    this.showBiometricFirstController,
    this.backgroundColor = Colors.white,
    this.backgroundColorOpacity = 0.5,
    this.onUnlocked,
  });

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  // receive from circle input button
  final StreamController<String> enteredStream = StreamController<String>();
  final StreamController<void> removedStreamController = StreamController<void>();
  final StreamController<int> enteredLengthStream = StreamController<int>.broadcast();
  final StreamController<bool> validateStreamController = StreamController<bool>();

  // control for Android back button
  // bool _needClose = false;

  // confirm flag
  bool _isConfirmation = false;

  // confirm verify passcode
  String _verifyConfirmPasscode = '';

  List<String> enteredValues = <String>[];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (widget.showBiometricFirst) {
      // // Maintain compatibility.
      // if (widget.biometricFunction != null) {
      //   // Set the listener if there is a stream option.
      //   if (widget.showBiometricFirstController != null) {
      //     widget.showBiometricFirstController.stream.listen((_) {
      //       widget.biometricFunction(context);
      //     });
      //   } else {
      //     // It is executed by a certain time.
      //     Future.delayed(
      //       Duration(milliseconds: 350),
      //       () {
      //         widget.biometricFunction(context);
      //       },
      //     );
      //   }
      // }

      if (widget.biometricAuthenticate != null) {
        // Set the listener if there is a stream option.
        if (widget.showBiometricFirstController != null) {
          widget.showBiometricFirstController.stream.listen((_) {
            widget.biometricAuthenticate(context).then((unlocked) {
              if (unlocked) {
                if (widget.onUnlocked != null) {
                  widget.onUnlocked();
                }

                // Navigator.of(context).pop();
              }
            });
          });
        } else {
          // It is executed by a certain time.
          Future.delayed(
            Duration(milliseconds: 350),
            () {
              widget.biometricAuthenticate(context).then((unlocked) {
                if (unlocked) {
                  if (widget.onUnlocked != null) {
                    widget.onUnlocked();
                  }
                  // Navigator.of(context).pop();
                }
              });
            },
          );
        }
      }
    }
  }

  void _removedStreamListener() {
    if (removedStreamController.hasListener) {
      return;
    }

    removedStreamController.stream.listen((_) {
      if (enteredValues.isNotEmpty) {
        enteredValues.removeLast();
      }

      enteredLengthStream.add(enteredValues.length);
    });
  }

  void _enteredStreamListener() {
    if (enteredStream.hasListener) {
      return;
    }

    enteredStream.stream.listen((value) {
      // add list entered value
      enteredValues.add(value);
      enteredLengthStream.add(enteredValues.length);

      // the same number of digits was entered.
      if (enteredValues.length == widget.digits) {
        var buffer = StringBuffer();
        enteredValues.forEach((value) {
          buffer.write(value);
        });
        _verifyCorrectString(buffer.toString());
      }
    });
  }

  void _verifyCorrectString(String enteredValue) {
    Future.delayed(Duration(milliseconds: 150), () {
      var _verifyPasscode = widget.correctString;

      if (widget.confirmMode) {
        if (_isConfirmation == false) {
          _verifyConfirmPasscode = enteredValue;
          enteredValues.clear();
          enteredLengthStream.add(enteredValues.length);
          _isConfirmation = true;
          setState(() {});
          return;
        }
        _verifyPasscode = _verifyConfirmPasscode;
      }

      if (enteredValue == _verifyPasscode) {
        // send valid status to DotSecretUI
        validateStreamController.add(true);
        enteredValues.clear();
        enteredLengthStream.add(enteredValues.length);

        if (widget.onCompleted != null) {
          // call user function
          widget.onCompleted(context, enteredValue);
        } else {
          // _needClose = true;
          // Navigator.of(context).pop();
        }

        if (widget.onUnlocked != null) {
          widget.onUnlocked();
        }
      } else {
        // send invalid status to DotSecretUI
        validateStreamController.add(false);
        enteredValues.clear();
        enteredLengthStream.add(enteredValues.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _enteredStreamListener();
    _removedStreamListener();

    var _rowMarginSize = MediaQuery.of(context).size.width * 0.025;
    var _columnMarginSize = MediaQuery.of(context).size.width * 0.065;
    var _heightMargiz = MediaQuery.of(context).size.height / 100;
    final bool _heightLess = _heightMargiz < 7.7;

    return WillPopScope(
      onWillPop: () async {
        if (widget.canCancel) {
          Navigator.pop(context, false);
          return true;
        }
        if (Platform.isAndroid) MoveToBackground.moveTaskToBack();

        return false;
      },
      child: Scaffold(
        backgroundColor: widget.backgroundColor.withOpacity(widget.backgroundColorOpacity),
        body: SafeArea(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
            child: Column(
              children: <Widget>[
                SizedBox(height: 5 * _heightMargiz),
                Image.asset(
                  'assets/images/lock_black.PNG',
                  scale: 3,
                ),
                SizedBox(height: (_heightLess ? 5.5 : 7) * _heightMargiz),
                _buildTitle(),
                DotSecretUI(
                  validateStream: validateStreamController.stream,
                  dots: widget.digits,
                  config: widget.dotSecretConfig,
                  enteredLengthStream: enteredLengthStream.stream,
                ),
                SizedBox(height: (_heightLess ? 5.5 : 8) * _heightMargiz),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _columnMarginSize,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _rowMarginSize - 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildNumberTextButton(context, '1'),
                            _buildNumberTextButton(context, '2'),
                            _buildNumberTextButton(context, '3'),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _rowMarginSize - 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildNumberTextButton(context, '4'),
                            _buildNumberTextButton(context, '5'),
                            _buildNumberTextButton(context, '6'),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _rowMarginSize - 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildNumberTextButton(context, '7'),
                            _buildNumberTextButton(context, '8'),
                            _buildNumberTextButton(context, '9'),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: _rowMarginSize - 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _heightLess
                                ? widget.canCancel
                                    ? _buildBothSidesButton(context, _cancleSideButton())
                                    : _buildBothSidesButton(context, _biometricButton())
                                : _buildBothSidesButton(context, _biometricButton()),
                            _buildNumberTextButton(context, '0'),
                            _heightLess ? _buildBothSidesButton(context, _deleteSideButton()) : _buildBothSidesButton(context, Container()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!_heightLess)
                  Container(
                    margin: EdgeInsets.symmetric(
                      // vertical: _rowMarginSize,
                      horizontal: _columnMarginSize + 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        widget.canCancel ? _buildBothSidesButton(context, _cancleSideButton()) : SizedBox.shrink(),
                        _buildBothSidesButton(context, _deleteSideButton()),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberTextButton(
    BuildContext context,
    String number,
  ) {
    final buttonSize = MediaQuery.of(context).size.width * 0.215;
    return Container(
      width: buttonSize - 5,
      height: buttonSize - 5,
      child: CircleInputButton(
        enteredSink: enteredStream.sink,
        text: number,
        config: widget.circleInputButtonConfig,
      ),
    );
  }

  Widget _buildBothSidesButton(BuildContext context, Widget button) {
    final buttonSize = MediaQuery.of(context).size.width * 0.215;
    return Container(
      width: buttonSize,
      height: buttonSize,
      child: button,
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        _isConfirmation ? widget.confirmTitle : widget.title,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _biometricButton() {
    if (!widget.canBiometric) return Container();

    return FlatButton(
      padding: EdgeInsets.all(0.0),
      child: widget.biometricButton,
      onPressed: () {
        // Maintain compatibility
        if (widget.biometricAuthenticate == null) {
          throw Exception('specify biometricFunction or biometricAuthenticate.');
        } else {
          // if (widget.biometricFunction != null) {
          //   widget.biometricFunction(context);
          // }

          if (widget.biometricAuthenticate != null) {
            widget.biometricAuthenticate(context).then((unlocked) {
              if (unlocked) {
                if (widget.onUnlocked != null) {
                  widget.onUnlocked();
                }

                // Navigator.of(context).pop();
              }
            });
          }
        }
      },
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget _cancleSideButton() {
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: Text(
        widget.cancelText,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.055,
          fontWeight: FontWeight.w300,
        ),
        softWrap: false,
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.transparent,
          style: BorderStyle.solid,
        ),
      ),
      color: Colors.transparent,
    );
  }

  Widget _deleteSideButton() {
    if (widget.rightSideButton != null) return widget.rightSideButton;

    return StreamBuilder<int>(
        stream: enteredLengthStream.stream,
        builder: (context, snapshot) {
          return FlatButton(
            padding: EdgeInsets.all(0),
            child: Text(
              widget.deleteText,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.055,
                fontWeight: FontWeight.w300,
              ),
              softWrap: false,
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              if (snapshot.hasData && snapshot.data > 0) {
                removedStreamController.sink.add(null);
              } else {
                // if (widget.canCancel) {
                //   _needClose = true;
                //   Navigator.of(context).pop();
                // }
              }
            },
            shape: CircleBorder(
              side: BorderSide(
                color: Colors.transparent,
                style: BorderStyle.solid,
              ),
            ),
            color: Colors.transparent,
          );
        });
  }

  @override
  void dispose() {
    enteredStream.close();
    enteredLengthStream.close();
    validateStreamController.close();
    removedStreamController.close();
    if (widget.showBiometricFirstController != null) {
      widget.showBiometricFirstController.close();
    }

    // restore orientation.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }
}
