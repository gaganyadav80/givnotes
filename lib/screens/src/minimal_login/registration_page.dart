import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/services/src/validators.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/blue_button.dart';

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

      Fluttertoast.showToast(msg: 'Will be added soon');
      // BlocProvider.of<AuthenticationBloc>(context).add(RegisterWithGoogle());
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthNeedsVerification) {
              Fluttertoast.showToast(msg: "Registration succesfull");
              Navigator.of(context)
                  .pushReplacementNamed(RouterName.verificationRoute);
            }
          },
          child: ListView(
            children: [
              // SizedBox(height: 50.w),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'Sign Up'.text.headline1(context).size(38.w).light.make(),
                    SizedBox(height: 33.w),
                    const RegisterForm(),
                    SizedBox(height: 25.w),
                    'or register with'
                        .text
                        .headline4(context)
                        .size(12.w)
                        .make()
                        .centered(),
                    SizedBox(height: 10.w),
                    Hero(
                      tag: 'google-button',
                      child: GoogleButton(
                        title: "Continue with Google",
                        onPressed: _onGoogleSignUpPressed,
                      ),
                    ),
                    SizedBox(height: 30.w),
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

    // if (_passtextController.text != _confirmPassTextController.text) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     content: Text('Passwords do not match', style: TextStyle(color: Colors.white)),
    //   ));
    //   return;
    // }

    //MAYBE add Terms and privacy policy
    // if (!acceptTnC) {
    //   context.showSnackBar("Please accept Terms and Conditions");
    //   return;
    // }

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
            prefixIcon: const Icon(Icons.person_outline_outlined),
            keyboardType: TextInputType.name,
            validator: _validator.validateName,
          ),
          SizedBox(height: 22.w),
          CustomTextFormField(
            currentNode: _emailNode,
            nextNode: _passwordNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            fieldController: _emailTextController,
            hintText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
          ),
          SizedBox(height: 22.w),
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
                prefixIcon: const Icon(Icons.lock_outline),
                keyboardType: TextInputType.text,
                validator: _validator.validatePassword,
                obscureText: _isObscure,
                suffix: _isObscure!
                    ? GestureDetector(
                        onTap: _onObscurePressed,
                        child: const Icon(Icons.visibility_off_outlined))
                    : GestureDetector(
                        onTap: _onObscurePressed,
                        child: const Icon(Icons.visibility_outlined)),
              );
            },
          ),
          SizedBox(height: 22.w),
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
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.text,
                    obscureText: _isConfirmObscure!,
                    textCapitalization: TextCapitalization.none,
                    textAlignVertical: TextAlignVertical.center,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.w),
                    decoration: InputDecoration(
                      suffixIcon: _isConfirmObscure!
                          ? GestureDetector(
                              onTap: _onConfirmObscurePressed,
                              child: const Icon(Icons.visibility_off_outlined))
                          : GestureDetector(
                              onTap: _onConfirmObscurePressed,
                              child: const Icon(Icons.visibility_outlined)),
                      border: kInputBorderStyle,
                      focusedBorder: kInputBorderStyle,
                      enabledBorder: kInputBorderStyle,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontSize: 14.w),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 20.w),
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      errorText: _passwordMatch.value,
                    ),
                  );
                },
              );
            },
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Checkbox(
          //       value: acceptTnC,
          //       onChanged: (newVal) {
          //         setState(() {
          //           acceptTnC = newVal;
          //         });
          //       },
          //       visualDensity: VisualDensity.compact,
          //     ),
          //     Text(
          //       "I accept ",
          //       style: Theme.of(context).textTheme.headline3.copyWith(
          //             fontSize: screenHeight * 0.01111817, // 10
          //           ),
          //     ),
          //     GestureDetector(
          //       onTap: () async {
          //         // launch("https://contri-app.web.app");
          //       },
          //       child: Text(
          //         "Terms and Conditions",
          //         style: Theme.of(context).textTheme.headline6.copyWith(
          //               fontSize: screenHeight * 0.01111817, // 10
          //             ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 22.w),

          '* Please store your password safely because it acts as your '
              .richText
              .xs
              .color(CupertinoColors.destructiveRed)
              .light
              .withTextSpanChildren(<TextSpan>[
            'MASTER KEY. '.textSpan.medium.italic.make(),
            'We won\'t be able to reset it for you.'.textSpan.light.make(),
          ]).make(),
          SizedBox(height: 22.w),

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
