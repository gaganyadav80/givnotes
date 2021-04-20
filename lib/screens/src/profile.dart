import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/font_awesome5_icons.dart' show FontAwesome5;
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/widgets/widgets.dart';

class MyProfile extends StatefulWidget {
  // bool isAnonymous;
  // final UserStore _userStore = locator.get<UserStore>();

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  double hm;
  double wm;

  @override
  Widget build(BuildContext context) {
    hm = 1.sh / 100;
    wm = 1.sw / 100;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.arrow_left, color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          User user;
          if (snapshot.hasData) {
            user = snapshot.data;
            final String photo = snapshot.data.photoURL;
            String initials = '';
            user.displayName.split(" ").forEach((element) {
              initials = initials + element[0];
            });

            return Column(
              children: [
                Padding(
                  // padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                  padding: EdgeInsets.symmetric(horizontal: 0.035.sw),
                  child: Stack(
                    children: <Widget>[
                      Card(
                        // margin: EdgeInsets.only(top: 8 * hm),
                        margin: EdgeInsets.only(top: 0.08.sh),
                        elevation: 1 * hm,
                        shadowColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.63 * wm),
                        ),
                        // *Profile Card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // SizedBox(height: 14 * wm),
                            SizedBox(height: 0.09.sh),
                            Padding(
                              // padding: EdgeInsets.symmetric(horizontal: 7 * wm),
                              padding: EdgeInsets.symmetric(horizontal: 0.07.sw),
                              child: Text(
                                user.displayName,
                                style: GoogleFonts.arizonia(
                                  color: Colors.black,
                                  fontSize: 4.5 * hm,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.12 * wm,
                                ),
                              ),
                            ),
                            Padding(
                              // padding: EdgeInsets.symmetric(horizontal: 7 * wm),
                              padding: EdgeInsets.symmetric(horizontal: 0.08.sw),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 2.5 * hm,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(height: (10 / 760).sh),
                                  !user.emailVerified
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Email is not verified. ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                // fontSize: 2.2 * hm,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Icon(
                                              CupertinoIcons.exclamationmark_circle,
                                              color: Colors.red,
                                              size: 16.0,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                            // SizedBox(height: 5.5 * hm),
                            SizedBox(height: 0.055.sh),
                            BlocBuilder<AuthenticationBloc, AuthenticationState>(
                              builder: (context, state) {
                                return state is LogoutInProgress
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
                                        child: Container(
                                          height: 0.077763158.sh,
                                          child: Center(
                                            child: Container(
                                              height: 30.0,
                                              width: 30.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.0,
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
                                        child: signInButton(context, true),
                                      );
                              },
                            ),
                            SizedBox(height: 0.02.sh),
                          ],
                        ),
                      ),
                      AvatarGlow(
                        glowColor: Colors.black,
                        endRadius: 17.4 * wm,
                        repeat: true,
                        showTwoGlows: true,
                        duration: Duration(seconds: 3),
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Material(
                          elevation: 5,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            radius: 10.5 * wm,
                            backgroundColor: Colors.black,
                            backgroundImage: photo != null ? NetworkImage(snapshot.data.photoURL) : null,
                            child: photo == null
                                ? Text(
                                    initials,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 0.0609137.sw,
                                      letterSpacing: 1.5,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  height: 0.269578947.sh,
                  width: double.infinity,
                  child: Image.asset('assets/img/profile.png'),
                ),
              ],
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.046.sw),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Lottie.asset(
                      'assets/animations/people-portrait.json',
                      height: 0.245.sh,
                      width: 0.463.sw,
                    ),
                  ),
                  SizedBox(height: 0.05.sh),
                  Text(
                    'Oops!',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 7.5 * wm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.006.sh),
                  Text(
                    'Looks like you are not logged in.',
                    style: TextStyle(
                      fontSize: 4.7 * wm,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  // SizedBox(height: 5 * hm),
                  SizedBox(height: 0.05.sh),
                  Container(
                    // height:8 * hm,
                    height: 0.08.sh,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(11.58 * wm),
                    ),
                    child: signInButton(context, false),
                  ),
                  // SizedBox(height: 5 * hm),
                  SizedBox(height: 0.05.sh),
                  Text(
                    'Not much here, yet. Maybe I\'ll add later.',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                      fontSize: 1.8 * hm,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget signInButton(BuildContext rootContext, bool isSignOut) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: Colors.grey[400],
        )
      ]),
      // height: 15 * wm,
      height: 0.077763158.sh,
      child: GFButton(
        elevation: 2,
        fullWidthButton: true,
        color: Colors.black,
        borderShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3 * wm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FontAwesome5.google,
              color: Colors.white,
              size: 5 * wm,
            ),
            // SizedBox(width: 2.6 * wm),
            SizedBox(width: 0.026.sw),
            Text(
              isSignOut == false ? 'Sign in' : 'Sign out',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 3 * hm,
              ),
            ),
          ],
        ),
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
                    mainButtonText: 'Log Out',
                    showCancel: true,
                    onTap: () async {
                      Navigator.pop(ctx);
                      BlocProvider.of<AuthenticationBloc>(rootContext).add(LogOutUser());
                      // setState(() {});
                    },
                  ),
                ).then((value) => Navigator.pop(rootContext));
                // _signOutAlert(context);
              },
      ),
    );
  }
}
