import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/widgets/blueButton.dart';

import 'bloc/verification_bloc/verification_bloc.dart';

class VerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.0.w),
            child: InkWell(
              onTap: () {
                // Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacementNamed(RouterName.homeRoute);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Do it later?",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontSize: 16.w,
                    ),
                  ),
                  SizedBox(width: 5.0.w),
                  Icon(Icons.fast_forward, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider<VerificationBloc>(
        create: (context) => VerificationBloc()..add(VerificationInitiated(isFirstTime: true)),
        child: VerificationMainBody(),
      ),
    );
  }
}

class VerificationMainBody extends StatelessWidget {
  void showSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(msg, style: TextStyle(color: Colors.white)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // bool isDark = Theme.of(context).brightness == Brightness.dark;
    void _onConfirmButtonPressed() {
      BlocProvider.of<VerificationBloc>(context).add(VerificationInitiated());
    }

    void _onResendButtonPressed() {
      BlocProvider.of<VerificationBloc>(context).add(ResendVerificationMail());
    }

    return BlocListener<VerificationBloc, VerificationState>(
      listener: (context, state) {
        if (state is VerificationFailed) {
          print("VERIFICATION ERROR ++++++ ${state.message}");
        }
        if (state is VerificationSuccess) {
          showSnackBar('Verification Successful', context);
          // Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed(RouterName.homeRoute);
        }
        //TODO handle resend and confirm verification @Gagan
        // if (state is VerificationInProgress) {
        //   showProgress(context);
        // }
        // if (state is ResendVerification) {
        //   BlocProvider.of<VerificationBloc>(context).add(VerificationInitiated());
        // }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.w),
                Center(
                    child: Image.asset(
                  "assets/img/login-verify.png",
                  height: 180.w,
                  width: 180.w,
                )),
                SizedBox(height: 40.w),
                Text(
                  "Waiting for Verification",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 27.w,
                        fontWeight: FontWeight.w300,
                      ),
                ),
                SizedBox(height: 27.w),
                Text(
                  "A verification email has been sent to your email",
                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14.w),
                ),
                Text(
                  "Verify by clicking on the link provided",
                  style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14.w),
                ),
                SizedBox(height: 45.w),
                BlocBuilder<VerificationBloc, VerificationState>(
                  builder: (context, state) {
                    return state is VerificationInProgress
                        ? BlueButton(title: "loading", onPressed: () {}, isLoading: true)
                        : BlueButton(title: "Confirm Verification", onPressed: _onConfirmButtonPressed);
                  },
                ),
                SizedBox(height: 45.w),
                BlocBuilder<VerificationBloc, VerificationState>(
                  builder: (context, state) {
                    return state is ResendVerificationInProgress
                        ? BlueButton(title: "loading", onPressed: () {}, isLoading: true)
                        : BlueButton(title: "Resend Verification Link", onPressed: _onResendButtonPressed);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
