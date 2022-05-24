import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/widgets.dart';

class ChangePasswordModalSheet extends StatefulWidget {
  const ChangePasswordModalSheet({Key? key}) : super(key: key);

  @override
  _ChangePasswordModalSheetState createState() => _ChangePasswordModalSheetState();
}

class _ChangePasswordModalSheetState extends State<ChangePasswordModalSheet> {
  final TextEditingController _passController = TextEditingController();

  final TextEditingController _newpassController = TextEditingController();

  final TextEditingController _reNewpassController = TextEditingController();

  @override
  Widget build(BuildContext rootContext) {
    return Material(
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
                  child: 'Done'.text.color(CupertinoColors.destructiveRed).medium.lg.make(),
                  onPressed: () => _onDonePress(),
                ),
              ),
              SizedBox(height: 30.h),
              const TilesDivider(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    _buildDetailTextField('Current', _passController, 'Enter your current password'),
                    const TilesDivider(),
                    _buildDetailTextField('New', _newpassController, 'Enter your new password'),
                    const TilesDivider(),
                    _buildDetailTextField('Confirm', _reNewpassController, 'Confirm your new password'),
                  ],
                ),
              ),
              const TilesDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildDetailTextField(String title, TextEditingController controller, String placeholder) {
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

  void _onDonePress() {
    hideKeyboard();

    if (_passController.text.isEmpty) {
      showToast('Please enter current password');
    } else if (_newpassController.text != _reNewpassController.text) {
      showToast('Passwords do not match');
    } else if (_newpassController.text.length < 6) {
      showToast('Weak password');
    } else {
      AuthController.to.updatePassword(_passController.text, _newpassController.text);
    }
  }
}

class BuildDeleteAccountDialog extends StatefulWidget {
  const BuildDeleteAccountDialog({Key? key}) : super(key: key);

  @override
  _BuildDeleteAccountDialogState createState() => _BuildDeleteAccountDialogState();
}

class _BuildDeleteAccountDialogState extends State<BuildDeleteAccountDialog> {
  final TextEditingController _deleteAccEmailController = TextEditingController();
  final TextEditingController _deleteAccPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deleteAccEmailController.text = AuthController.to.currentUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
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
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              controller: _deleteAccEmailController,
              enabled: false,
              placeholder: "example@email.com",
              decoration: const BoxDecoration(
                color: CupertinoColors.systemGrey4,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
        ),
      ].vStack(axisSize: MainAxisSize.min, crossAlignment: CrossAxisAlignment.start),
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
              hideKeyboard();
              AuthController.to.deleteUserAccount(_deleteAccPassController.text);
            } else {
              showToast('Please enter password');
            }
          },
        )
      ],
    );
  }
}
