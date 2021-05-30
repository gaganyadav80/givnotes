import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:givnotes/screens/screens.dart';

import 'circular_loading.dart';

/// commented out all the Navigator.of(context).pop();
/// to make it work with AppLock package

class SimpleLockScreen extends StatefulWidget {
  final String correctString;
  final String title;
  final String confirmTitle;
  final bool confirmMode;
  final bool canCancel;
  final void Function(BuildContext, String) onCompleted;
  final bool canBiometric;
  final bool showBiometricFirst;
  final Future<bool> Function(BuildContext) biometricAuthenticate;
  final void Function() onUnlocked;

  final bool isAddingLock;

  SimpleLockScreen({
    this.correctString,
    this.title = 'Enter Passcode',
    this.confirmTitle = 'Enter Confirm Passcode',
    this.confirmMode = false,
    this.canCancel = true,
    this.onCompleted,
    this.canBiometric = false,
    this.showBiometricFirst = false,
    this.biometricAuthenticate,
    this.onUnlocked,
    this.isAddingLock = false,
  });

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<SimpleLockScreen> with SingleTickerProviderStateMixin {
  final StreamController<bool> validateStreamController = StreamController<bool>.broadcast();
  final StreamController<String> titleStreamController = StreamController<String>.broadcast();

  final TextEditingController appLockPassController = TextEditingController();
  final TextEditingController resetLockUserPassController = TextEditingController();
  final TextEditingController resetLockUserEmailController = TextEditingController();
  final FocusNode applockFocusNode = FocusNode();

  Animation<Offset> _animation;
  AnimationController _animationController;

  RxBool _isConfirmation = false.obs;
  RxString _verifyConfirmPasscode = ''.obs;

  @override
  void initState() {
    super.initState();

    validateStreamController.stream.listen((valid) {
      if (!valid) {
        // shake animation when invalid
        _animationController.forward();
      }
    });

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 80));

    _animation = _animationController
        .drive(CurveTween(curve: Curves.elasticIn))
        .drive(Tween<Offset>(begin: Offset.zero, end: const Offset(0.050, 0)))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            }
          });
  }

  void _verifyCorrectString(String enteredValue) {
    // Future.delayed(Duration(milliseconds: 150), () {
    var _verifyPasscode = widget.correctString;

    if (widget.confirmMode) {
      if (_isConfirmation.value == false) {
        _verifyConfirmPasscode.value = enteredValue;
        appLockPassController.clear();
        _isConfirmation.value = true;
        titleStreamController.add(widget.confirmTitle);
        return;
      }
      _verifyPasscode = _verifyConfirmPasscode.value;
    }

    if (enteredValue == _verifyPasscode) {
      // send valid status to DotSecretUI
      validateStreamController.add(true);
      // if (!widget.canCancel) titleStreamController.add('Success');

      if (widget.onCompleted != null) {
        widget.onCompleted(context, enteredValue);
      }

      if (widget.onUnlocked != null) {
        widget.onUnlocked();
      }
    } else {
      // send invalid status to DotSecretUI
      validateStreamController.add(false);
      titleStreamController.add(_isConfirmation.value ? 'Passcode Does Not Match' : 'Wrong Passcode');
    }
    appLockPassController.clear();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.canCancel) {
          Navigator.pop(context, false);
        }
        // if (Platform.isAndroid) MoveToBackground.moveTaskToBack();

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: widget.canCancel
              ? IconButton(
                  icon: Icon(CupertinoIcons.back),
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context, false),
                )
              : Container(),
          actions: <Widget>[
            !widget.isAddingLock
                ? ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 56.0),
                    child: IconButton(
                      icon: Icon(CupertinoIcons.question_circle),
                      color: CupertinoColors.systemGrey,
                      tooltip: "Forgot AppLock?",
                      onPressed: () => showCupertinoDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (context) {
                          return _buildForgotApplockDialog();
                        },
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            //TODO Replace simple lockscreen image @Gagan
            Image.asset("assets/img/simple-lockscreen.png", width: 220.w, height: 238.w),
            SizedBox(height: 10.w),
            _buildTitle(),
            SizedBox(height: 10.w),
            _buildTextField(),
            SizedBox(height: 40.w),
            widget.canBiometric ? _buildBiometric() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: CupertinoTextField(
          controller: appLockPassController,
          focusNode: applockFocusNode,
          // autocorrect: false,
          autofocus: widget.isAddingLock,
          cursorColor: Colors.black,
          cursorWidth: 1.5,
          keyboardType: TextInputType.number,
          expands: false,
          maxLines: 1,
          obscureText: true,
          obscuringCharacter: '✱',
          placeholder: 'Enter Your Password',
          clearButtonMode: OverlayVisibilityMode.editing,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          style: TextStyle(fontSize: 18.w),
          onSubmitted: (value) {
            value = value.trim();
            if (value.isEmpty) {
              validateStreamController.add(false);
              titleStreamController.add("Enter a password");
            } else if (value.length < 4) {
              validateStreamController.add(false);
              titleStreamController.add("Password too short");
            } else {
              _verifyCorrectString(value);
            }
            applockFocusNode.requestFocus();
          },
          suffix: IconButton(
            icon: Icon(CupertinoIcons.arrow_turn_down_left),
            color: Colors.black,
            onPressed: () => appLockPassController.clear(),
          ),
          suffixMode: OverlayVisibilityMode.editing,
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.withBrightness(
              color: CupertinoColors.systemGrey6.withOpacity(0.4),
              darkColor: CupertinoColors.black,
            ),
            border: Border.all(
              color: CupertinoDynamicColor.withBrightness(
                color: Color(0x33000000),
                darkColor: Color(0x33FFFFFF),
              ),
              style: BorderStyle.solid,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5.r)),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometric() {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(80.r),
          onTap: () {
            // Maintain compatibility
            if (widget.biometricAuthenticate == null) {
              throw Exception('specify biometricFunction or biometricAuthenticate.');
            } else {
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
          child: Container(
            height: 70.w,
            width: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CupertinoColors.systemGrey6.withOpacity(0.4),
              border: Border.all(
                color: CupertinoDynamicColor.withBrightness(
                  color: Color(0x33000000),
                  darkColor: Color(0x33FFFFFF),
                ),
                style: BorderStyle.solid,
                width: 1.0,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/img/faceid.png',
                height: 35.w,
                width: 35.w,
              ),
            ),
          ),
        ),
      ),
    );
  }

  final double _kFontSize = 22.w;
  final FontWeight _kFontWeight = FontWeight.w500;

  Widget _buildTitle() {
    return Center(
      child: SlideTransition(
        position: _animation,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 15.h),
          child: StreamBuilder<String>(
            stream: titleStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                // if (snapshot.data != false) {
                return Text(
                  snapshot.data,
                  style: TextStyle(fontSize: _kFontSize, fontWeight: _kFontWeight),
                );
                // } else {
                //   return Text(
                //     _isConfirmation ? 'Passcode Does Not Match' : 'Wrong Passcode',
                //     style: TextStyle(fontSize: _kFontSize, fontWeight: _kFontWeight),
                //   );
                // }
              } else {
                return Text(
                  _isConfirmation.value ? widget.confirmTitle : widget.title,
                  style: TextStyle(fontSize: _kFontSize, fontWeight: _kFontWeight),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    validateStreamController.close();
    titleStreamController.close();
    _animationController.dispose();
    appLockPassController.dispose();
    resetLockUserEmailController.dispose();
    resetLockUserPassController.dispose();
    applockFocusNode.dispose();

    super.dispose();
  }

  Widget _buildForgotApplockDialog() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.verify) {
            if (state.verifyFailed)
              Fluttertoast.showToast(msg: "Verification failed");
            else
              Fluttertoast.showToast(msg: "Will be implemented");
          }
        } else if (state is AuthNeedsVerification) {
          if (state.verify) {
            if (state.verifyFailed)
              Fluttertoast.showToast(msg: "Verification failed");
            else
              Fluttertoast.showToast(msg: "Will be implemented");
          }
        }
      },
      child: CupertinoAlertDialog(
        title: Text("Forgot AppLock?"),
        content: Column(
          children: <Widget>[
            SizedBox(height: 5.w),
            Text(
              "Send applock password on your registered email. Please verify your details for security purpose.",
            ),
            SizedBox(height: 15.w),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is LoginInProgress) {
                  return Center(
                    child: CircularLoading(),
                  );
                } else if (state is AuthSuccess) {
                  resetLockUserEmailController.text = state.user.email;
                } else if (state is AuthNeedsVerification) {
                  resetLockUserEmailController.text = state.user.email;
                } else {
                  resetLockUserEmailController.clear();
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoTextField(
                      controller: resetLockUserEmailController,
                      enabled: resetLockUserEmailController.text.isEmpty,
                      placeholder: "example@email.com",
                      decoration: BoxDecoration(
                        color: resetLockUserEmailController.text.isEmpty
                            ? CupertinoColors.white
                            : CupertinoColors.systemGrey4,
                        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    SizedBox(height: 10),
                    CupertinoTextField(
                      controller: resetLockUserPassController,
                      obscureText: true,
                      placeholder: 'enter password',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              resetLockUserPassController.clear();
              resetLockUserEmailController.clear();
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Send mail'),
            onPressed: () {
              if (resetLockUserPassController.text.isNotEmpty) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoginButtonPressed(
                    email: resetLockUserEmailController.text,
                    password: resetLockUserPassController.text,
                    verify: true,
                  ),
                );
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(msg: 'Please enter password');
              }
            },
          ),
        ],
      ),
    );
  }
}
