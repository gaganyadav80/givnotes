import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:givnotes/global/validators/validators.dart';
import 'package:givnotes/routes.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  void showSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(msg, style: TextStyle(color: Colors.white)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignInPressed() {
      BlocProvider.of<AuthenticationBloc>(context).add(LoginWithGoogle());
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Google Sign In"),
      // ));
    }

    void _onSignUpPressed() {
      Navigator.of(context).pushNamed(RouterName.signupRouter);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Colors.black),
        leading: ModalRoute.of(context).canPop
            ? InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: Colors.black),
              )
            : null,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) async {
          if (state is AuthFailure) {
            print(state.message);
            if (state.message.contains('password is invalid'))
              showSnackBar("Invalid password", context);
            else if (state.message.contains('no user record'))
              showSnackBar("Invalid email", context);
            else
              showSnackBar("Login Failure", context);
          }
          if (state is AuthSuccess) {
            showSnackBar("Login successfull", context);
            Navigator.of(context).pushReplacementNamed(RouterName.homeRoute);
          }
          if (state is AuthNeedsVerification) {
            Navigator.of(context).pushReplacementNamed(RouterName.verificationRoute);
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
                  Text(
                    "Welcome",
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: 38.w,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  SizedBox(height: 33.w),
                  LoginForm(),
                  SizedBox(height: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "or connect with",
                        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13.w),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.w),
                  GoogleButton(
                    title: "Continue with Google",
                    onPressed: _onGoogleSignInPressed,
                  ),
                  SizedBox(height: 100.w),
                  GestureDetector(
                    onTap: _onSignUpPressed,
                    child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: kBorderRadius,
                        // border: Border.all(width: 1.0, color: Colors.grey[500].withOpacity(0.5)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.w), // 13.5
                      child: Center(
                        child: Text(
                          "Create a new account.",
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: 14.w,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ),
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
  bool _isObscure = true;

  void _onLoginButtonPressed() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState.validate()) return;
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
          if (!_formKey.currentState.validate()) return;

          BlocProvider.of<AuthenticationBloc>(context).add(ForgetPassword(email: _emailController.text));
        },
      ),
    );
  }

  void _onObscurePressed() {
    _isObscure = !_isObscure;
    BlocProvider.of<AuthenticationBloc>(context).add(LoginObscureEvent(obscureLogin: _isObscure));
  }

  @override
  void dispose() {
    _emailTextController?.dispose();
    _passtextController?.dispose();
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
            prefixIcon: Icon(Icons.email_outlined),
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
                prefixIcon: Icon(Icons.lock_outline),
                keyboardType: TextInputType.text,
                validator: _validator.validatePassword,
                obscureText: _isObscure,
                suffix: _isObscure
                    ? GestureDetector(onTap: _onObscurePressed, child: Icon(Icons.visibility_off_outlined))
                    : GestureDetector(onTap: _onObscurePressed, child: Icon(Icons.visibility_outlined)),
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
                  style: Theme.of(context).textTheme.headline6.copyWith(
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
                  : BlueButton(title: "Sign In", onPressed: _onLoginButtonPressed);
            },
          )
        ],
      ),
    );
  }
}
