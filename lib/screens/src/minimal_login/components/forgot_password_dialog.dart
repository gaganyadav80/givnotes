import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/services/services.dart';

import 'constants.dart';
import 'custom_form_field.dart';

class PassResetMailDialog extends StatelessWidget {
  final Function onPressed;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const PassResetMailDialog({
    Key key,
    @required this.onPressed,
    @required this.formKey,
    @required this.emailController,
  }) : super(key: key);

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
      content: SizedBox(
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
                prefixIcon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: Validator().validateEmail,
                maxLines: 1,
              ),
              SizedBox(height: 10.w),
              '* You will not be able to access your data. Resetting your password also '
                  .richText
                  .caption(context)
                  .withTextSpanChildren(<TextSpan>[
                'RESETS YOUR MASTER KEY.'.textSpan.semiBold.italic.make(),
              ]).make(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("CONFIRM"),
        ),
      ],
    );
  }
}
