import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/database/database.dart';
import 'package:givnotes/routes.dart';
import 'package:givnotes/services/services.dart';
import 'package:givnotes/widgets/custom_buttons.dart';

import '../todo_timeline/todo_timeline.dart';
import 'bloc/verification_bloc/verification_bloc.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<VerificationBloc>(
          create: (context) => VerificationBloc()..add(const VerificationInitiated(isFirstTime: true)),
          child: const VerificationMainBody(),
        ),
      ),
    );
  }
}

class VerificationMainBody extends StatelessWidget {
  const VerificationMainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onConfirmButtonPressed() {
      BlocProvider.of<VerificationBloc>(context).add(const VerificationInitiated());
    }

    void _onResendButtonPressed() {
      BlocProvider.of<VerificationBloc>(context).add(ResendVerificationMail());
    }

    return BlocListener<VerificationBloc, VerificationState>(
      listener: (context, state) async {
        if (state is VerificationFailed) {
          showToast(state.message!);
        } else if (state is VerificationSuccess) {
          showToast('verification successful');

          AuthController.to.userModel.value.copyWith(verified: true);
          await DBHelper.updateUserModelJson(AuthController.to.currentUser.toJson());
          await FireDBHelper.updateUser(AuthController.to.currentUser);

          Get.offAllNamed(RouterName.homeRoute);
        } else if (state is ResendVerification) {
          showToast('verification mail sent');
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    delayedOnPressed(() {
                      Navigator.of(context).pushReplacementNamed(RouterName.homeRoute);
                    });
                  },
                  child: <Widget>[
                    Text(
                      "Skip",
                      style: TextStyle(color: Colors.black, fontSize: 18.w),
                    ),
                    HSpace(5.w),
                    const Icon(LineIcons.arrowRight, color: Colors.black)
                  ].hStack(),
                ),
              ),
              VSpace(20.w),
              Center(
                  child: Image.asset(
                "assets/img/login-verify.png",
                height: 200.w,
                width: 200.w,
              )),
              VSpace(40.w),
              'Waiting for Verification'.text.xl3.extraBlack.make(),
              VSpace(12.w),
              Text(
                "A verification link has been sent to your email address. Please confirm your signup.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14.w),
              ).pSymmetric(h: 10.w),
              VSpace(45.w),
              BlocBuilder<VerificationBloc, VerificationState>(
                builder: (context, state) {
                  return state is VerificationInProgress
                      ? const BlueButton(title: "loading", onPressed: null, isLoading: true)
                      : BlueButton(title: "Confirm Verification", onPressed: _onConfirmButtonPressed);
                },
              ),
              VSpace(22.w),
              BlocBuilder<VerificationBloc, VerificationState>(
                builder: (context, state) {
                  return state is ResendVerificationInProgress
                      ? BorderTextButton(title: "loading", onPressed: () {}, isLoading: true)
                      : BorderTextButton(title: "Resend Verification Link", onPressed: _onResendButtonPressed);
                },
              ),
              VSpace(40.w),
              <Widget>[
                "Not ${(AuthController.to.currentUser.email)}?".text.size(14.w).make(),
                TextButton(
                  onPressed: () {
                    AuthController.to.logOut();
                    BlocProvider.of<TodosBloc>(context).add(LoadTodos());
                    Get.offAllNamed(RouterName.loginRoute);
                  },
                  child: 'Go back'.text.size(14.w).color(Theme.of(context).primaryColor).make(),
                ).centered(),
              ].hStack(),
            ],
          ),
        ),
      ),
    );
  }
}
