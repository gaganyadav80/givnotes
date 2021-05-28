import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:givnotes/global/variables.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/circular_loading.dart';
import 'package:givnotes/widgets/widgets.dart';

import '../minimal_login/components/components.dart';
import 'profile_widgets.dart';

class MyProfile extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back, color: Colors.black),
        ),
        centerTitle: true,
        title: 'Account'.text.black.make(),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xfffafafa),
      body: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          User user;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularLoading(color: Colors.black, size: 50.0),
            ).pOnly(bottom: 120.h);
          } else if (snapshot.hasError) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/giv_img/logged_out_light.png'),
                "Oh O! \nSomething went wrong.".text.center.size(18.w).make().pOnly(bottom: 20.w),
                BlueButton(
                  title: 'Try Again',
                  onPressed: () => Fluttertoast.showToast(msg: "Will be added soon"),
                ).w(150.w).h(60.w),
              ],
            ).pOnly(top: 140.h);
          } else if (snapshot.hasData) {
            user = snapshot.data;
            _nameController.text = user.displayName;
            _emailController.text = user.email;
            _passwordController.text = '12345678';

            return ListView(
              children: [
                CircleAvatar(
                  radius: 70.r,
                  backgroundColor: Colors.transparent,
                  child: user.photoURL != null
                      ? Image.network(user.photoURL)
                      : SvgPicture.asset('assets/user-imgs/user$randomUserProfile.svg'),
                ).pOnly(top: 40.w),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: <Widget>[
                    Icon(CupertinoIcons.camera_fill, size: 18.w, color: CupertinoColors.systemBlue)
                        .pOnly(bottom: 2.0, right: 5.w),
                    'Edit'.text.medium.xl.color(CupertinoColors.systemBlue).make().centered(),
                  ].hStack(),
                  onPressed: () => Fluttertoast.showToast(msg: 'Will be added'),
                ).pOnly(bottom: 20.w),
                TilesDivider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDetailTextField(title: 'Name', controller: _nameController),
                      TilesDivider(),
                      _buildDetailTextField(title: 'Email', controller: _emailController),
                      TilesDivider(),
                      _buildDetailTextField(
                        context: context,
                        title: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                TilesDivider(),
                SizedBox(height: 40.w),
                signInButton(context, true).pSymmetric(h: 20.w),
                SizedBox(height: 20.w),
                TilesDivider(),
                Container(
                  height: 50.w,
                  color: Colors.white,
                  width: context.screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: 'Delete Account'
                      .text
                      .medium
                      .color(CupertinoColors.destructiveRed.withOpacity(0.8))
                      .make()
                      .objectCenterLeft(),
                ).onTap(() => showCupertinoDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (context) => BuildDeleteAccountDialog(),
                ),),
                TilesDivider(),
              ],
            ).centered();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Lottie.asset('assets/animations/people-portrait.json', height: 180.h, width: 195.w),
                ),
                SizedBox(height: 40.h),
                'Oops!'.text.teal600.size(32.w).medium.make(),
                SizedBox(height: 5.h),
                'Looks like you are not logged in.'.text.gray400.light.size(20.w).make(),
                SizedBox(height: 40.h),
                signInButton(context, false),
                SizedBox(height: 40.h),
                'Not much here, yet. Maybe I\'ll add later.'.text.light.gray400.italic.size(14.h).make(),
              ],
            ).pSymmetric(h: 20.w);
          }
        },
      ),
    );
  }

  Padding _buildDetailTextField(
      {BuildContext context, String title, TextEditingController controller, isPassword = false}) {
    return Row(
      children: [
        Expanded(child: title.text.gray400.make()),
        Expanded(
          flex: 3,
          child: CupertinoTextField.borderless(
            controller: controller,
            readOnly: isPassword,
            obscureText: isPassword,
            style: isPassword ? TextStyle(color: CupertinoColors.systemGrey2) : null,
            obscuringCharacter: '✱',
            suffix: isPassword ? Icon(CupertinoIcons.forward, color: CupertinoColors.systemGrey) : null,
            onTap: isPassword
                ? () => showCupertinoModalBottomSheet(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ChangePasswordModalSheet(),
                    )
                : null,
          ),
        ),
      ],
    ).pSymmetric(v: 10.w);
  }

  Widget signInButton(BuildContext rootContext, bool isSignOut) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return BlueButton(
          title: isSignOut ? 'Sign out' : 'Sign in',
          isLoading: state is LoginInProgress ? true : false,
          onPressed: isSignOut == false
              ? () {
                  Navigator.pushNamed(rootContext, RouterName.loginRoute);
                }
              : () async {
                  await showDialog(
                    context: rootContext,
                    useRootNavigator: false,
                    builder: (ctx) => GivnotesDialog(
                      title: 'Log Out',
                      message: 'Do you really want to log out?',
                      mainButtonText: 'Sign Out',
                      showCancel: true,
                      onTap: () async {
                        Navigator.pop(ctx, true); // close the dialog
                        BlocProvider.of<AuthenticationBloc>(rootContext).add(LogOutUser()); //send logout event
                      },
                    ),
                  ).then((value) {
                    if (value) Navigator.pop(rootContext); // pop profile page if logout is clicked
                  });
                },
        );
      },
    );
  }
}
