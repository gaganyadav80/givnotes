import 'package:flutter/material.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/global/validators/validators.dart';
import 'package:givnotes/screens/src/new_login_page/components/customFormField.dart';
import 'package:givnotes/screens/src/new_login_page/constants.dart';

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
              fontSize: screenHeight * 0.030685206,
            ),
      ),
      content: Container(
        width: screenWidth * 0.80,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.028246941),
              CustomTextFormField(
                fieldController: emailController,
                hintText: "Enter registered email",
                prefixIcon: Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: Validator().validateEmail,
                maxLines: 1,
              ),
              SizedBox(height: screenHeight * 0.025246941),
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
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("CANCEL"),
        ),
        FlatButton(
          onPressed: onPressed,
          child: Text("CONFIRM"),
        ),
      ],
    );
  }
}
