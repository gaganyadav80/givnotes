import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/global/validators/validators.dart';
import 'package:givnotes/packages/toast.dart';
import 'package:givnotes/screens/src/new_login_page/components/blueButton.dart';
import 'package:givnotes/screens/src/new_login_page/components/customFormField.dart';
import 'package:givnotes/screens/src/new_login_page/pages/login_page.dart';
import 'package:givnotes/screens/src/new_login_page/register_bloc/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: RegisterMainBody(),
      ),
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

      BlocProvider.of<RegisterBloc>(context).add(GoogleSignUpClicked());
    }

    void _onSignInPressed() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return LoginPage();
      }));
    }

    return SafeArea(
      child: BlocConsumer(
        listener: (context, state) {
          if (state is RegisterFailed) {}
          if (state is RegisterSuccess) {}
          if (state is RegisterInProgress) {}
        },
        builder: (context, state) {
          return ListView(
            children: [
              SizedBox(
                height: screenHeight * 0.142312579, // 128
              ),
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
                            fontSize: screenHeight * 0.042249047, //38
                          ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.036689962, //33
                    ),
                    RegisterForm(),
                    SizedBox(
                      height: screenHeight * 0.053367217, // 48
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validator = Validator();
  // static bool acceptTnC = false;
  bool _isObscure = true;

  void _onRegisterButtonPressed() {
    if (!_formKey.currentState.validate()) return;

    // if (!acceptTnC) {
    //   //TODO: complete
    //   // context.showSnackBar("Please accept Terms and Conditions");
    //   return;
    // }
    BlocProvider.of<RegisterBloc>(context).add(
      RegisterButtonClicked(
        email: _emailTextController.text,
        password: _passtextController.text,
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
            prefixIcon: Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
          ),
          SizedBox(height: screenHeight * 0.024459975), // 22
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
          BlueButton(title: "Sign Up", onPressed: _onRegisterButtonPressed),
        ],
      ),
    );
  }
}
