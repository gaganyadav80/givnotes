import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/global/size_utils.dart';
import 'package:givnotes/global/validators/validators.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';

import 'components/components.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: giveStatusBarColor(context),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.arrow_left, color: Colors.black),
        ),
      ),
      body: RegisterMainBody(),
    );
  }
}

class RegisterMainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _onGoogleSignUpPressed() {
      // if (!_RegisterFormState.acceptTnC) {
      //   context.showSnackBar("Please accept Terms and Conditions");
      //   return;
      // }

      BlocProvider.of<AuthenticationBloc>(context).add(RegisterWithGoogle());
    }

    // void _onSignInPressed() {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
    //     return LoginPage();
    //   }));
    // }

    return SafeArea(
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            Toast.show(state.message, context);
          }
          if (state is AuthSuccess) {
            Toast.show("Registration succesfull", context);
            Navigator.of(context).pushReplacementNamed(RouterName.verificationRoute);
          }
          // if (state is RegisterInProgress) {
          //   showProgress(context);
          // }
        },
        child: ListView(
          children: [
            SizedBox(height: screenHeight * 0.07),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.072916667), // 30
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.headline1.copyWith(
                          fontSize: screenWidth * 0.0964467005, //38
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.036689962, //33
                  ),
                  RegisterForm(),
                  SizedBox(height: screenHeight * 0.035),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "or register with",
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: screenWidth * 0.0308629,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  GoogleButton(
                    title: "Sign Up with Google",
                    onPressed: _onGoogleSignUpPressed,
                  ),
                  SizedBox(height: screenHeight * 0.045),
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
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  ValueNotifier<String> _passwordMatch = ValueNotifier<String>(null);

  @override
  void dispose() {
    _emailTextController?.dispose();
    _passtextController?.dispose();
    _nametextController?.dispose();
    _confirmPassTextController?.dispose();
    super.dispose();
  }

  void _onRegisterButtonPressed() {
    _passwordMatch.value = _validator.validateConfirmPassword(
      confirmPassword: _confirmPassTextController.text,
      newPassword: _passtextController.text,
    );

    if (!_formKey.currentState.validate()) {
      print('not validated');
      return;
    }
    if (_passwordMatch.value != null) {
      print('password do not match');
      return;
    }

    // if (_passtextController.text != _confirmPassTextController.text) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     content: Text('Passwords do not match', style: TextStyle(color: Colors.white)),
    //   ));
    //   return;
    // }

    // if (!acceptTnC) {
    //   //TODO: complete
    //   // context.showSnackBar("Please accept Terms and Conditions");
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
    _isObscure = !_isObscure;
    BlocProvider.of<AuthenticationBloc>(context).add(RegisterObscureEvent(obscure: _isObscure, obscureConfirm: _isConfirmObscure));
  }

  void _onConfirmObscurePressed() {
    _isConfirmObscure = !_isConfirmObscure;
    BlocProvider.of<AuthenticationBloc>(context).add(RegisterObscureEvent(obscure: _isObscure, obscureConfirm: _isConfirmObscure));
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
            prefixIcon: Icon(Icons.person_outline_outlined),
            keyboardType: TextInputType.name,
            validator: _validator.validateName,
          ),
          SizedBox(height: screenHeight * 0.024459975),
          CustomTextFormField(
            currentNode: _emailNode,
            nextNode: _passwordNode,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            fieldController: _emailTextController,
            hintText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
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
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is RegisterObscureState) {
                _isConfirmObscure = state.obscureConfirm;
              }
            },
            builder: (context, state) {
              return ValueListenableBuilder(
                valueListenable: _passwordMatch,
                builder: (context, value, child) {
                  return Container(
                    child: TextFormField(
                      focusNode: _confirmPassNode,
                      onFieldSubmitted: (value) {
                        if (_passtextController.text.isNotEmpty) {
                          return _passwordMatch.value = _validator.validateConfirmPassword(
                            confirmPassword: value,
                            newPassword: _passtextController.text,
                          );
                        }

                        if (_confirmPassNode != null) {
                          _confirmPassNode.unfocus();
                        }
                      },
                      onChanged: (value) {
                        if (_passtextController.text.isNotEmpty) {
                          return _passwordMatch.value = _validator.validateConfirmPassword(
                            confirmPassword: value,
                            newPassword: _passtextController.text,
                          );
                        }
                      },
                      textInputAction: TextInputAction.done,
                      maxLines: 1,
                      controller: _confirmPassTextController,
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.text,
                      obscureText: _isConfirmObscure,
                      textCapitalization: TextCapitalization.none,
                      textAlignVertical: TextAlignVertical.center,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: screenWidth * 0.03553299, // 14
                          ),
                      decoration: InputDecoration(
                        suffixIcon: _isConfirmObscure
                            ? GestureDetector(onTap: _onConfirmObscurePressed, child: Icon(Icons.visibility_off_outlined))
                            : GestureDetector(onTap: _onConfirmObscurePressed, child: Icon(Icons.visibility_outlined)),
                        border: kInputBorderStyle,
                        focusedBorder: kInputBorderStyle,
                        enabledBorder: kInputBorderStyle,
                        hintStyle: Theme.of(context).textTheme.caption.copyWith(
                              fontSize: screenWidth * 0.03553299, // 14
                            ),
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.036458333, vertical: screenHeight * 0.021124524), // h=15, v=19
                        hintText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        errorText: _passwordMatch.value,
                      ),
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
          SizedBox(height: screenHeight * 0.024459975), // 22
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              return state is RegisterInProgress
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
