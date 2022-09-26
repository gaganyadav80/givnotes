import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/custom_buttons.dart';

import 'components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onGoogleSignInPressed() {
      showToast('Will be added soon');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // VSpace(50.w),
              'Welcome'.text.size(38.w).extraBlack.make(),
              <Widget>[
                'New here?'.text.size(18.w).make(),
                TextButton(
                  onPressed: () => delayedOnPressed(() {
                    Get.toNamed(RouterName.signupRouter);
                  }),
                  child: 'Create a new account.'.text.size(14.w).color(Theme.of(context).primaryColor).make(),
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
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _validator = Validator();

  void _onLoginButtonPressed() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    AuthController.to.logInWithEmailAndPassword();
  }

  //TODO: add this to controller - business logic
  void _onLoginObscurePressed() {
    AuthController.to.isLoginObscure.toggle();
    AuthController.to.update(['login-password-field']);
  }

  void _onForgetPasswordPressed() {
    final _formKey = GlobalKey<FormState>();
    delayedOnPressed(() {
      showDialog(
        context: context,
        builder: (context) => PassResetMailDialog(
          formKey: _formKey,
          emailController: AuthController.to.emailTextController,
          onPressed: () {
            showToast('TODO: Will be added soon');
          },
        ),
      );
    });
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
            fieldController: AuthController.to.emailTextController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: _validator.validateEmail,
            prefixIcon: const Icon(LineIcons.envelope),
          ),
          VSpace(22.w),
          GetBuilder<AuthController>(
            id: 'login-password-field',
            builder: (_) {
              return CustomTextFormField(
                currentNode: _passwordNode,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                fieldController: AuthController.to.passtextController,
                hintText: 'Password',
                keyboardType: TextInputType.text,
                validator: _validator.validatePassword,
                obscureText: !AuthController.to.isLoginObscure.value,
                prefixIcon: const Icon(LineIcons.lock),
                suffix: !AuthController.to.isLoginObscure.value
                    ? InkWell(
                        onTap: _onLoginObscurePressed,
                        child: const Icon(LineIcons.eyeSlash, color: Colors.grey),
                      )
                    : InkWell(onTap: _onLoginObscurePressed, child: const Icon(LineIcons.eye)),
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
          GetBuilder<AuthController>(
            id: 'login-button',
            builder: (AuthController controller) {
              return controller.authStatus.value == AuthStatus.loginInProgress
                  ? const BlueButton(
                      title: "loading",
                      onPressed: null,
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
