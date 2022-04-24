import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:givnotes/screens/src/minimal_login/minimal_login.dart';
import 'package:givnotes/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordModalSheet extends StatefulWidget {
  const ChangePasswordModalSheet({Key? key}) : super(key: key);

  @override
  _ChangePasswordModalSheetState createState() =>
      _ChangePasswordModalSheetState();
}

class _ChangePasswordModalSheetState extends State<ChangePasswordModalSheet> {
  final TextEditingController _passController = TextEditingController();

  final TextEditingController _newpassController = TextEditingController();

  final TextEditingController _reNewpassController = TextEditingController();

  @override
  Widget build(BuildContext rootContext) {
    return Material(
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            if (state.verify) {
              if (state.verifyFailed) {
                Fluttertoast.showToast(msg: "Verification failed");
              } else {
                FirebaseAuth.instance.currentUser!
                    .updatePassword(_newpassController.text);
                Navigator.pop(rootContext);
              }
            }
          } else if (state is AuthNeedsVerification) {
            if (state.verify) {
              if (state.verifyFailed) {
                Fluttertoast.showToast(msg: "Verification failed");
              } else {
                FirebaseAuth.instance.currentUser!
                    .updatePassword(_newpassController.text);
                Navigator.pop(rootContext);
              }
            }
          }
        },
        child: Builder(
          builder: (context) => CupertinoPageScaffold(
            backgroundColor: const Color(0xffFAFAFA),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey3,
                      borderRadius: BorderRadius.circular(15.0.r),
                    ),
                    height: 5.0.h,
                    width: 50.0.w,
                  ).centered().pSymmetric(v: 10.h),
                ),
                CupertinoNavigationBar(
                  middle: const Text('Password'),
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(CupertinoIcons.xmark_circle_fill),
                    color: CupertinoColors.systemGrey3,
                    onPressed: () => Navigator.pop(rootContext),
                  ),
                  trailing: TextButton(
                    child: 'Done'
                        .text
                        .color(CupertinoColors.destructiveRed)
                        .medium
                        .lg
                        .make(),
                    onPressed: () => _onDonePress(rootContext),
                  ),
                ),
                SizedBox(height: 30.h),
                const TilesDivider(),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      _buildDetailTextField('Current', _passController,
                          'Enter your current password'),
                      const TilesDivider(),
                      _buildDetailTextField(
                          'New', _newpassController, 'Enter your new password'),
                      const TilesDivider(),
                      _buildDetailTextField('Confirm', _reNewpassController,
                          'Confirm your new password'),
                    ],
                  ),
                ),
                const TilesDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildDetailTextField(
      String title, TextEditingController controller, String placeholder) {
    return Row(
      children: [
        Expanded(child: title.text.lg.gray400.make()),
        Expanded(
          flex: 3,
          child: CupertinoTextField.borderless(
            controller: controller,
            placeholder: placeholder,
            obscureText: placeholder.contains('new'),
            obscuringCharacter: '✱',
          ),
        ),
      ],
    ).pSymmetric(v: 10.w);
  }

  void _onDonePress(BuildContext rtContext) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (_newpassController.text != _reNewpassController.text) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
    } else if (_newpassController.text.length < 6) {
      Fluttertoast.showToast(msg: 'Weak password');
    } else {
      BlocProvider.of<AuthenticationBloc>(rtContext).add(
        LoginButtonPressed(
          email: FirebaseAuth.instance.currentUser!.email!,
          password: _passController.text,
          verify: true,
        ),
      );
    }
  }
}

class BuildDeleteAccountDialog extends StatefulWidget {
  const BuildDeleteAccountDialog({Key? key}) : super(key: key);

  @override
  _BuildDeleteAccountDialogState createState() =>
      _BuildDeleteAccountDialogState();
}

class _BuildDeleteAccountDialogState extends State<BuildDeleteAccountDialog> {
  final TextEditingController _deleteAccEmailController =
      TextEditingController();
  final TextEditingController _deleteAccPassController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.verify) {
            if (state.verifyFailed) {
              Fluttertoast.showToast(msg: "Verification failed");
            } else {
              FirebaseAuth.instance.currentUser!.delete();
              Navigator.pop(context);
            }
          }
        } else if (state is AuthNeedsVerification) {
          if (state.verify) {
            if (state.verifyFailed) {
              Fluttertoast.showToast(msg: "Verification failed");
            } else {
              FirebaseAuth.instance.currentUser!.delete();
              Navigator.pop(context);
            }
          }
        }
      },
      child: CupertinoAlertDialog(
        title: const Text('Delete Account?'),
        content: <Widget>[
          const Text('Please verify for confirmation.').centered(),
          SizedBox(height: 10.w),
          const Text(
            'Following will be lost:',
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const Text(
            '  1. All your To-Do\'s\n'
            '  2. All your subcriptions (paid/unpaid)\n'
            '  3. Database backup capabilities\n',
            textAlign: TextAlign.left,
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is LoginInProgress) {
                return const Center(
                  child: CircularLoading(),
                );
              } else if (state is AuthSuccess) {
                _deleteAccEmailController.text = state.user!.email;
              } else if (state is AuthNeedsVerification) {
                _deleteAccEmailController.text = state.user!.email;
              } else {
                _deleteAccEmailController.clear();
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoTextField(
                    controller: _deleteAccEmailController,
                    enabled: _deleteAccEmailController.text.isEmpty,
                    placeholder: "example@email.com",
                    decoration: BoxDecoration(
                      color: _deleteAccEmailController.text.isEmpty
                          ? CupertinoColors.white
                          : CupertinoColors.systemGrey4,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    controller: _deleteAccPassController,
                    obscureText: true,
                    placeholder: 'Enter password',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              );
            },
          ),
        ].vStack(
            axisSize: MainAxisSize.min,
            crossAlignment: CrossAxisAlignment.start),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('Delete'),
            isDestructiveAction: true,
            onPressed: () {
              if (_deleteAccPassController.text.isNotEmpty) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoginButtonPressed(
                    email: _deleteAccEmailController.text,
                    password: _deleteAccPassController.text,
                    verify: true,
                  ),
                );
              } else {
                Fluttertoast.showToast(msg: 'Please enter password');
              }
            },
          )
        ],
      ),
    );
  }
}
