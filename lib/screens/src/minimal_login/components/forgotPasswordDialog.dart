import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:givnotes/global/validators/validators.dart';

import 'constants.dart';
import 'customFormField.dart';

//TODO user custom dialog
class PassResetMailDialog extends StatelessWidget {
  final Function onPressed;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  PassResetMailDialog({
    @required this.onPressed,
    @required this.formKey,
    @required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: kBorderRadius),
      title: Text(
        "Forgot Password",
        style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: 22.w,
              fontWeight: FontWeight.w300,
            ),
      ),
      content: Container(
        width: 315.w,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.w),
              CustomTextFormField(
                fieldController: emailController,
                hintText: "Enter registered email",
                prefixIcon: Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: Validator().validateEmail,
                maxLines: 1,
              ),
              SizedBox(height: 20.w),
              Text(
                "A link will be sent to your registered email Id. Click on the link to reset your password",
                style: Theme.of(context).textTheme.caption,
              ),
              // SizedBox(height: screenHeight * 0.025),
              // FlatButton(
              //   padding: EdgeInsets.zero,
              //   onPressed: () async {
              //     await CustomerSupport.mailToSupport(
              //       subject: "Trouble Signing In",
              //       body: "Please%20explain%20your%20issue%briefly",
              //     );
              //     await FirebaseAnalytics().logEvent(name: 'trouble_signing_in');
              //   },
              //   child: Text(
              //     "Trouble signing in? Contact Us",
              //     style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.w600),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("CANCEL"),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text("CONFIRM"),
        ),
      ],
    );
  }
}
