import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:givnotes/services/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/custom_buttons.dart';

import 'components/components.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignUpPressed() {
      // if (!_RegisterFormState.acceptTnC) {
      //   context.showSnackBar("Please accept Terms and Conditions");
      //   return;
      // }

      showToast(msg: 'Will be added soon');
      // BlocProvider.of<AuthenticationBloc>(context).add(RegisterWithGoogle());
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
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthNeedsVerification) {
              showToast(msg: "Registration succesfull");
              Navigator.of(context)
                  .pushReplacementNamed(RouterName.verificationRoute);
            }
          },
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
  final _emailTextController = TextEditingController();
  final _passtextController = TextEditingController();
  final _nametextController = TextEditingController();
  final _confirmPassTextController = TextEditingController();

  final _nameNode = FocusNode();
  final _confirmPassNode = FocusNode();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  // static bool acceptTnC = false;
  bool? _isObscure = true;
  bool? _isConfirmObscure = true;

  final ValueNotifier<String?> _passwordMatch = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _emailTextController.dispose();
    _passtextController.dispose();
    _nametextController.dispose();
    _confirmPassTextController.dispose();
    super.dispose();
  }

  void _onRegisterButtonPressed() {
    _passwordMatch.value = _validator.validateConfirmPassword(
      confirmPassword: _confirmPassTextController.text,
      newPassword: _passtextController.text,
    );

    if (!_formKey.currentState!.validate()) {
      log('not validated');
      return;
    }
    if (_passwordMatch.value != null) {
      log('password do not match');
      return;
    }

    BlocProvider.of<AuthenticationBloc>(context).add(
      RegisterButtonClicked(
        name: _nametextController.text,
        email: _emailTextController.text,
        password: _passtextController.text,
      ),
    );
  }

  void _onObscurePressed() {
    _isObscure = !_isObscure!;
    BlocProvider.of<AuthenticationBloc>(context).add(RegisterObscureEvent(
        obscure: _isObscure, obscureConfirm: _isConfirmObscure));
  }

  void _onConfirmObscurePressed() {
    _isConfirmObscure = !_isConfirmObscure!;
    BlocProvider.of<AuthenticationBloc>(context).add(RegisterObscureEvent(
        obscure: _isObscure, obscureConfirm: _isConfirmObscure));
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
            fieldController: _nametextController,
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
            fieldController: _emailTextController,
            hintText: 'Email',
            prefixIcon: const Icon(LineIcons.envelope),
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
          ),
          VSpace(22.w),
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is RegisterObscureState) {
                _isObscure = state.obscure;
                // _isConfirmObscure = state.obscureConfirm;
              }
            },
            builder: (context, state) {
              return CustomTextFormField(
                currentNode: _passwordNode,
                nextNode: _confirmPassNode,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                maxLength: 32,
                fieldController: _passtextController,
                hintText: 'Password',
                prefixIcon: const Icon(LineIcons.lock),
                keyboardType: TextInputType.text,
                validator: _validator.validatePassword,
                obscureText: _isObscure,
                suffix: _isObscure!
                    ? InkWell(
                        onTap: _onObscurePressed,
                        child:
                            const Icon(LineIcons.eyeSlash, color: Colors.grey))
                    : InkWell(
                        onTap: _onObscurePressed,
                        child: const Icon(LineIcons.eye)),
              );
            },
          ),
          VSpace(22.w),
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is RegisterObscureState) {
                _isConfirmObscure = state.obscureConfirm;
              }
            },
            builder: (context, state) {
              return ValueListenableBuilder(
                valueListenable: _passwordMatch,
                builder: (context, dynamic value, child) {
                  return TextFormField(
                    focusNode: _confirmPassNode,
                    onFieldSubmitted: (value) {
                      if (_passtextController.text.isNotEmpty) {
                        _passwordMatch.value =
                            _validator.validateConfirmPassword(
                          confirmPassword: value,
                          newPassword: _passtextController.text,
                        );
                      }

                      _confirmPassNode.unfocus();
                    },
                    onChanged: (value) {
                      if (_passtextController.text.isNotEmpty) {
                        _passwordMatch.value =
                            _validator.validateConfirmPassword(
                          confirmPassword: value,
                          newPassword: _passtextController.text,
                        );
                      }
                    },
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    maxLength: 32,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: _confirmPassTextController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    obscureText: _isConfirmObscure!,
                    textCapitalization: TextCapitalization.none,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 14.w),
                    decoration: InputDecoration(
                      suffixIcon: _isConfirmObscure!
                          ? InkWell(
                              onTap: _onConfirmObscurePressed,
                              child: const Icon(LineIcons.eyeSlash,
                                  color: Colors.grey))
                          : InkWell(
                              onTap: _onConfirmObscurePressed,
                              child: const Icon(LineIcons.eye)),
                      border: kInputBorderStyle,
                      focusedBorder: kInputBorderStyle,
                      enabledBorder: kInputBorderStyle,
                      // hintStyle: Theme.of(context)
                      //     .textTheme
                      //     .caption!
                      //     .copyWith(fontSize: 14.w),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 20.w),
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
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return state is RegisterInProgress
                  ? BlueButton(
                      title: "loading",
                      onPressed: () {},
                      isLoading: true,
                    )
                  : BlueButton(
                      title: "Sign Up", onPressed: _onRegisterButtonPressed);
            },
          )
        ],
      ),
    );
  }
}
