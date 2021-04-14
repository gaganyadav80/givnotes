import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/validators/validators.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'components/components.dart';
import 'registration_page.dart';

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
      Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) {
        return RegisterPage();
      }));
    }

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: giveStatusBarColor(context),
    //   ),
    // );
    return SafeArea(
      child: Scaffold(
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
              // Navigator.of(context).pop();
              showSnackBar("Login successfull", context);
              Navigator.of(context).pushReplacementNamed('home_p');
            }
            // if (state is LoginInProgress) {
            //   showProgress(context);
            // }
            if (state is AuthNeedsVerification) {
              // showSnackBar("User email is not verified. Please verify your email id", context);
              Navigator.of(context).pushReplacementNamed('verification_p');
            }
            if (state is ForgetPasswordSuccess) {}
          },
          child: ListView(
            children: [
              // SizedBox(
              //   height: screenHeight * 0.142312579, // 128
              // ),
              SizedBox(height: screenHeight * 0.07),
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
                            fontSize: screenWidth * 0.0964467005, //38
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    SizedBox(
                      height: screenWidth * 0.08375634517, //33
                    ),
                    LoginForm(),
                    SizedBox(height: screenWidth * 0.051),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "or connect with",
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                fontSize: screenWidth * 0.0328629,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    GoogleButton(
                      title: "Continue with Google",
                      onPressed: _onGoogleSignInPressed,
                    ),
                    SizedBox(height: screenHeight * 0.14),
                    GestureDetector(
                      onTap: _onSignUpPressed,
                      child: Container(
                        decoration: BoxDecoration(
                          // borderRadius: kBorderRadius,
                          // border: Border.all(width: 1.0, color: Colors.grey[500].withOpacity(0.5)),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01500953), // 13.5
                        child: Center(
                          child: Text(
                            "Create a new account.",
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: screenWidth * 0.034,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: screenHeight * 0.045),
                  ],
                ), // 30
              ),
            ],
          ),
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
          SizedBox(height: screenHeight * 0.024459975),
          // 22
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
          SizedBox(height: screenHeight * 0.024459975), // 22
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _onForgetPasswordPressed,
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontSize: screenWidth * 0.025076,
                        color: Theme.of(context).iconTheme.color,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              // Theme(
              //   data: ThemeData(cupertinoOverrideTheme: CupertinoThemeData(brightness: Brightness.dark)),
              //   child: CupertinoActivityIndicator(),
              // );
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
