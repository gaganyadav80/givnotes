import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/widgets/blue_button.dart';

import 'bloc/verification_bloc/verification_bloc.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key? key}) : super(key: key);

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
            padding: EdgeInsets.only(right: 20.0.w),
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(RouterName.homeRoute);
              },
              icon: Text(
                "Skip",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: 16.w,
                ),
              ),
              label: const Icon(Icons.fast_forward, color: Colors.black),
            ),
          ),
        ],
      ),
      body: BlocProvider<VerificationBloc>(
        create: (context) => VerificationBloc()
          ..add(const VerificationInitiated(isFirstTime: true)),
        child: const VerificationMainBody(),
      ),
    );
  }
}

class VerificationMainBody extends StatelessWidget {
  const VerificationMainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onConfirmButtonPressed() {
      BlocProvider.of<VerificationBloc>(context)
          .add(const VerificationInitiated());
    }

    void _onResendButtonPressed() {
      BlocProvider.of<VerificationBloc>(context).add(ResendVerificationMail());
    }

    return BlocListener<VerificationBloc, VerificationState>(
      listener: (context, state) {
        if (state is VerificationFailed) {
          Fluttertoast.showToast(msg: state.message!);
        } else if (state is VerificationSuccess) {
          Fluttertoast.showToast(msg: 'verification successful');
          Navigator.of(context).pushReplacementNamed(RouterName.homeRoute);
        } else if (state is ResendVerification) {
          Fluttertoast.showToast(msg: 'verification mail sent');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
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
                'Waiting for Verification'
                    .text
                    .headline1(context)
                    .xl3
                    .light
                    .make(),
                SizedBox(height: 27.w),
                Text(
                  "A verification email has been sent to your email",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 14.w),
                ),
                Text(
                  "Verify by clicking on the link provided",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 14.w),
                ),
                SizedBox(height: 45.w),
                BlocBuilder<VerificationBloc, VerificationState>(
                  builder: (context, state) {
                    return state is VerificationInProgress
                        ? const BlueButton(
                            title: "loading", onPressed: null, isLoading: true)
                        : BlueButton(
                            title: "Confirm Verification",
                            onPressed: _onConfirmButtonPressed);
                  },
                ),
                SizedBox(height: 45.w),
                BlocBuilder<VerificationBloc, VerificationState>(
                  builder: (context, state) {
                    return state is ResendVerificationInProgress
                        ? BlueButton(
                            title: "loading", onPressed: () {}, isLoading: true)
                        : BlueButton(
                            title: "Resend Verification Link",
                            onPressed: _onResendButtonPressed);
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
