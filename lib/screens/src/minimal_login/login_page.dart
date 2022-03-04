import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/services/services.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/widgets/blue_button.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignInPressed() {
      Fluttertoast.showToast(msg: 'Will be added soon');
      // BlocProvider.of<AuthenticationBloc>(context).add(LoginWithGoogle());
    }

    void _onSignUpPressed() {
      Navigator.of(context).pushNamed(RouterName.signupRouter);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: ModalRoute.of(context)!.canPop
            ? InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.black),
              )
            : null,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthFailure) {
            Fluttertoast.showToast(msg: state.message!);
          }
          if (state is AuthSuccess) {
            Fluttertoast.showToast(msg: "Authentication successfull");
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
            SizedBox(height: 50.w),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Welcome'.text.headline1(context).size(38.w).light.make(),
                  SizedBox(height: 33.w),
                  const LoginForm(),
                  SizedBox(height: 20.w),
                  'or connect with'
                      .text
                      .headline4(context)
                      .size(13.w)
                      .make()
                      .centered(),
                  SizedBox(height: 10.w),
                  Hero(
                    tag: 'google-button',
                    child: GoogleButton(
                      title: "Continue with Google",
                      onPressed: _onGoogleSignInPressed,
                    ),
                  ),
                  SizedBox(height: 100.w),
                  TextButton(
                    onPressed: _onSignUpPressed,
                    child: 'Create a new account.'
                        .text
                        .caption(context)
                        .size(14.w)
                        .semiBold
                        .make(),
                  ).centered(),
                  // SizedBox(height: screenHeight * 0.045), //30
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
    showDialog(
      context: context,
      builder: (context) => PassResetMailDialog(
        formKey: _formKey,
        emailController: _emailController,
        onPressed: () {
          Fluttertoast.showToast(msg: 'TODO: Will be added soon');
          // if (!_formKey.currentState.validate()) return;

          // BlocProvider.of<AuthenticationBloc>(context).add(ForgetPassword(email: _emailController.text));
        },
      ),
    );
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
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          SizedBox(height: 22.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _onForgetPasswordPressed,
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontSize: 10.w,
                        color: Theme.of(context).iconTheme.color,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 22.w),
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
