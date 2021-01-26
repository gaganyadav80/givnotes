import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/global/validators/validators.dart';
import 'package:givnotes/packages/packages.dart';

import 'components/components.dart';
import 'login_bloc/login_bloc.dart';
import 'registration_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: Scaffold(body: LoginMainBody()),
    );
  }
}

class LoginMainBody extends StatelessWidget {
  const LoginMainBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignInPressed() {
      BlocProvider.of<LoginBloc>(context).add(LoginWithGoogle());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Google Sign In"),
      ));
    }

    void _onSignUpPressed() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return RegisterPage();
      }));
    }

    return SafeArea(
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginFailure) {
            Navigator.of(context).pop();
            Toast.show(state.message, context);
          }
          if (state is LoginSuccess) {
            Navigator.of(context).pop();
            Toast.show('Login Successful', context);
            Navigator.of(context).pushReplacementNamed('home_p');
          }
          if (state is LoginInProgress) {
            showProgress(context);
          }
          if (state is LoginNeedsVerification) {
            Toast.show("User email is not verified. Please verify your email id", context);
            Navigator.of(context).pushReplacementNamed('verification_p');
          }
          if (state is ForgetPasswordSuccess) {}
        },
        builder: (context, state) {
          return ListView(
            children: [
              SizedBox(
                height: screenHeight * 0.142312579, // 128
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.072916667),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: screenHeight * 0.042249047, //38
                          ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.036689962, //33
                    ),
                    LoginForm(),
                    SizedBox(
                      height: screenHeight * 0.053367217, // 48
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "or connect with",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                fontSize: screenHeight * 0.01111817, // 10
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.053367217, // 48
                    ),
                    GoogleButton(
                      title: "Continue with Google",
                      onPressed: _onGoogleSignInPressed,
                    ),
                    SizedBox(height: screenHeight * 0.180462516), // 183
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: screenHeight * 0.01111817, // 10
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        GestureDetector(
                          onTap: _onSignUpPressed,
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context).textTheme.headline6.copyWith(
                                  fontSize: screenHeight * 0.01111817, // 10
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                  ],
                ), // 30
              ),
            ],
          );
        },
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
    if (!_formKey.currentState.validate()) return;
    BlocProvider.of<LoginBloc>(context).add(
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

          BlocProvider.of<LoginBloc>(context).add(ForgetPassword(email: _emailController.text));
        },
      ),
    );
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
          SizedBox(height: screenHeight * 0.024459975),
          // 22
          CustomTextFormField(
            currentNode: _passwordNode,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            fieldController: _passtextController,
            hintText: 'Password',
            prefixIcon: Icon(Icons.lock_outline),
            keyboardType: TextInputType.text,
            validator: _validator.validatePassword,
            obscureText: _isObscure,
            suffix: _isObscure ? Icon(Icons.visibility_off_outlined) : Icon(Icons.visibility_outlined),
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _onForgetPasswordPressed,
                child: Text(
                  "FORGOT PASWWORD",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: screenHeight * 0.01111817, // 10
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          BlueButton(title: "Sign In", onPressed: _onLoginButtonPressed),
        ],
      ),
    );
  }
}
