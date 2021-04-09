import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givnotes/global/size_utils.dart';

import 'components/components.dart';
import 'verification_bloc/verification_bloc.dart';

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
            padding: EdgeInsets.only(right: 30.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacementNamed('home_p');
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Do it later?",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontSize: screenWidth * 0.040609, //16,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Icon(
                    Icons.fast_forward,
                    color: Theme.of(context).splashColor,
                  ),
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed('home_p');
        }
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.072916667), // 30
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Center(
                    child: Image.asset(
                  isDark ? "assets/giv_img/lock_dark.png" : "assets/giv_img/lock_light.png",
                  height: 180,
                  width: 180,
                )),
                SizedBox(height: screenHeight * 0.044472681), // 40
                Text(
                  "Waiting for Verification",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: screenWidth * 0.06852791, // 27
                        fontWeight: FontWeight.w300,
                      ),
                ),
                SizedBox(height: screenHeight * 0.03001906), // 27
                Text(
                  "A verification email has been sent to your email",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: screenWidth * 0.035532994, // 14
                      ),
                ),
                Text(
                  "Verify by clicking on the link provided",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: screenWidth * 0.035532994, // 14
                      ),
                ),
                SizedBox(height: screenHeight * 0.050031766), // 45
                BlocBuilder<VerificationBloc, VerificationState>(
                  builder: (context, state) {
                    return state is VerificationInProgress
                        ? BlueButton(title: "loading", onPressed: () {}, isLoading: true)
                        : BlueButton(title: "Confirm Verification", onPressed: _onConfirmButtonPressed);
                  },
                ),
                SizedBox(height: screenHeight * 0.025031766), // 45
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
