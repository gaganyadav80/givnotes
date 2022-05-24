import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/custom_buttons.dart';

import 'components/components.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignUpPressed() {
      showToast('Will be added soon');
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(LineIcons.arrowLeft, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // VSpace(50.w),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Sign Up'.text.size(38.w).extraBlack.make(),
                  VSpace(36.w),
                  const RegisterForm(),
                  VSpace(25.w),
                  'or register with'.text.size(14.w).make().centered(),
                  VSpace(16.w),
                  Hero(
                    tag: 'google-button',
                    child: GoogleButton(
                      title: "Continue with Google",
                      onPressed: _onGoogleSignUpPressed,
                    ),
                  ),
                  VSpace(30.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameNode = FocusNode();
  final _confirmPassNode = FocusNode();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validator = Validator();

  final ValueNotifier<String?> _passwordMatch = ValueNotifier<String?>(null);

  //TODO: move to auth controller - business logic
  void _onRegisterButtonPressed() {
    _passwordMatch.value = _validator.validateConfirmPassword(
      confirmPassword: AuthController.to.confirmPassTextController.text,
      newPassword: AuthController.to.passtextController.text,
    );

    if (!_formKey.currentState!.validate()) {
      log('not validated');
      return;
    }
    if (_passwordMatch.value != null) {
      log('password do not match');
      return;
    }

    AuthController.to.signUpWithEmailAndPassword();
  }

  void _onObscurePressed() {
    AuthController.to.isRegisterObscure.toggle();
    AuthController.to.update(['register-password-field']);
  }

  void _onConfirmObscurePressed() {
    AuthController.to.isRegisterConfirmObscure.toggle();
    AuthController.to.update(['register-confirm-password-field']);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            currentNode: _nameNode,
            nextNode: _emailNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            fieldController: AuthController.to.nameTextController,
            hintText: 'Name',
            prefixIcon: const Icon(LineIcons.user),
            keyboardType: TextInputType.name,
            validator: _validator.validateName,
          ),
          VSpace(22.w),
          CustomTextFormField(
            currentNode: _emailNode,
            nextNode: _passwordNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            fieldController: AuthController.to.emailTextController,
            hintText: 'Email',
            prefixIcon: const Icon(LineIcons.envelope),
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
          ),
          VSpace(22.w),
          GetBuilder<AuthController>(
            id: 'register-password-field',
            builder: (controller) {
              return CustomTextFormField(
                currentNode: _passwordNode,
                nextNode: _confirmPassNode,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                maxLength: 32,
                fieldController: controller.passtextController,
                hintText: 'Password',
                prefixIcon: const Icon(LineIcons.lock),
                keyboardType: TextInputType.text,
                validator: _validator.validatePassword,
                obscureText: controller.isRegisterObscure.value,
                suffix: controller.isRegisterObscure.value
                    ? InkWell(onTap: _onObscurePressed, child: const Icon(LineIcons.eyeSlash, color: Colors.grey))
                    : InkWell(onTap: _onObscurePressed, child: const Icon(LineIcons.eye)),
              );
            },
          ),
          VSpace(22.w),
          GetBuilder<AuthController>(
            id: 'register-confirm-password-field',
            builder: (controller) {
              return ValueListenableBuilder(
                valueListenable: _passwordMatch,
                builder: (context, dynamic value, child) {
                  return TextFormField(
                    focusNode: _confirmPassNode,
                    onFieldSubmitted: (value) {
                      if (controller.passtextController.text.isNotEmpty) {
                        _passwordMatch.value = _validator.validateConfirmPassword(
                          confirmPassword: value,
                          newPassword: controller.passtextController.text,
                        );
                      }

                      _confirmPassNode.unfocus();
                    },
                    onChanged: (value) {
                      if (controller.passtextController.text.isNotEmpty) {
                        _passwordMatch.value = _validator.validateConfirmPassword(
                          confirmPassword: value,
                          newPassword: controller.passtextController.text,
                        );
                      }
                    },
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    maxLength: 32,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: controller.confirmPassTextController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    obscureText: controller.isRegisterConfirmObscure.value,
                    textCapitalization: TextCapitalization.none,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 14.w),
                    decoration: InputDecoration(
                      suffixIcon: controller.isRegisterConfirmObscure.value
                          ? InkWell(
                              onTap: _onConfirmObscurePressed,
                              child: const Icon(LineIcons.eyeSlash, color: Colors.grey),
                            )
                          : InkWell(onTap: _onConfirmObscurePressed, child: const Icon(LineIcons.eye)),
                      border: kInputBorderStyle,
                      focusedBorder: kInputBorderStyle,
                      enabledBorder: kInputBorderStyle,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.w),
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(LineIcons.lock),
                      errorText: _passwordMatch.value,
                    ),
                  );
                },
              );
            },
          ),
          VSpace(20.w),
          '* Please store your password safely because it acts as your '
              .richText
              .xs
              .color(CupertinoColors.destructiveRed)
              .light
              .withTextSpanChildren(<TextSpan>[
            'MASTER KEY. '.textSpan.medium.italic.make(),
            'We won\'t be able to reset it for you.'.textSpan.light.make(),
          ]).make(),
          VSpace(20.w),
          GetBuilder<AuthController>(
            id: 'register-button',
            builder: (controller) {
              return controller.authStatus.value == AuthStatus.registerInProgress
                  ? BlueButton(
                      title: "loading",
                      onPressed: () {},
                      isLoading: true,
                    )
                  : BlueButton(title: "Sign Up", onPressed: _onRegisterButtonPressed);
            },
          )
        ],
      ),
    );
  }
}
