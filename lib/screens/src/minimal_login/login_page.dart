import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/services/services.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/widgets/custom_buttons.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignInPressed() {
      showToast(msg: 'Will be added soon');
      // BlocProvider.of<AuthenticationBloc>(context).add(LoginWithGoogle());
    }

    void _onSignUpPressed() {
      delayedOnPressed(() {
        Navigator.of(context).pushNamed(RouterName.signupRouter);
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: ModalRoute.of(context)!.canPop
            ? InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(LineIcons.times, color: Colors.black),
              )
            : null,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthFailure) {
            showToast(msg: state.message!);
          }
          if (state is AuthSuccess) {
            showToast(msg: "Authentication successfull");
            Navigator.of(context).pushReplacementNamed(RouterName.homeRoute);
          }
          if (state is AuthNeedsVerification) {
            Navigator.of(context)
                .pushReplacementNamed(RouterName.verificationRoute);
          }
          if (state is ForgetPasswordSuccess) {}
        },
        child: ListView(
          children: [
            VSpace(50.w),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Welcome'.text.size(38.w).extraBlack.make(),
                  <Widget>[
                    'New here?'.text.size(18.w).make(),
                    TextButton(
                      onPressed: _onSignUpPressed,
                      child: 'Create a new account.'
                          .text
                          .size(14.w)
                          .color(Theme.of(context).primaryColor)
                          .make(),
                    ).centered(),
                  ].hStack(),
                  VSpace(25.w),
                  const LoginForm(),
                  VSpace(32.w),
                  'or connect with'.text.size(14.w).make().centered(),
                  VSpace(16.w),
                  Hero(
                    tag: 'google-button',
                    child: GoogleButton(
                      title: "Continue with Google",
                      onPressed: _onGoogleSignInPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailTextController = TextEditingController();
  final _passtextController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  bool? _isObscure = true;

  void _onLoginButtonPressed() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    BlocProvider.of<AuthenticationBloc>(context).add(
      LoginButtonPressed(
        email: _emailTextController.text,
        password: _passtextController.text,
      ),
    );
  }

  void _onForgetPasswordPressed() {
    final _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    delayedOnPressed(() {
      showDialog(
        context: context,
        builder: (context) => PassResetMailDialog(
          formKey: _formKey,
          emailController: _emailController,
          onPressed: () {
            showToast(msg: 'TODO: Will be added soon');
            // if (!_formKey.currentState.validate()) return;

            // BlocProvider.of<AuthenticationBloc>(context).add(ForgetPassword(email: _emailController.text));
          },
        ),
      );
    });
  }

  void _onObscurePressed() {
    _isObscure = !_isObscure!;
    BlocProvider.of<AuthenticationBloc>(context)
        .add(LoginObscureEvent(obscureLogin: _isObscure));
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passtextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            currentNode: _emailNode,
            nextNode: _passwordNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            fieldController: _emailTextController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
            prefixIcon: const Icon(LineIcons.envelope),
          ),
          VSpace(22.w),
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is LoginObscureState) {
                _isObscure = state.obscure;
              }
            },
            builder: (context, state) {
              return CustomTextFormField(
                currentNode: _passwordNode,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                fieldController: _passtextController,
                hintText: 'Password',
                keyboardType: TextInputType.text,
                validator: _validator.validatePassword,
                obscureText: _isObscure,
                prefixIcon: const Icon(LineIcons.lock),
                suffix: _isObscure!
                    ? InkWell(
                        onTap: _onObscurePressed,
                        child:
                            const Icon(LineIcons.eyeSlash, color: Colors.grey),
                      )
                    : InkWell(
                        onTap: _onObscurePressed,
                        child: const Icon(LineIcons.eye)),
              );
            },
          ),
          VSpace(12.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _onForgetPasswordPressed,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(fontSize: 12.w, color: Colors.black),
                ),
              ),
            ],
          ),
          VSpace(12.w),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return state is LoginInProgress
                  ? BlueButton(
                      title: "loading",
                      onPressed: () {},
                      isLoading: true,
                    )
                  : BlueButton(
                      title: "Sign In", onPressed: _onLoginButtonPressed);
            },
          )
        ],
      ),
    );
  }
}
