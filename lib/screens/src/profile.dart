import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:givnotes/global/utils.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/themes/app_themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

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
    hm = MediaQuery.of(context).size.height / 100;
    wm = MediaQuery.of(context).size.width / 100;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: GiveStatusBarColor(context),
      ),
    );
    //TODO too much to rebuild... redesign
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
            "Gagan Yadav".split(" ").forEach((element) {
              initials = initials + element[0];
            });

            return Column(
              children: [
                Padding(
                  // padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                  padding: EdgeInsets.symmetric(horizontal: 0.035 * screenSize.width),
                  child: Stack(
                    children: <Widget>[
                      Card(
                        // margin: EdgeInsets.only(top: 8 * hm),
                        margin: EdgeInsets.only(top: 0.08 * screenSize.height),
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
                            SizedBox(height: 0.09 * screenSize.height),
                            Padding(
                              // padding: EdgeInsets.symmetric(horizontal: 7 * wm),
                              padding: EdgeInsets.symmetric(horizontal: 0.07 * screenSize.width),
                              child: Text(
                                user.displayName ?? "Gagan Yadav",
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
                              padding: EdgeInsets.symmetric(horizontal: 0.07 * screenSize.width),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 2.5 * hm,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  !user.emailVerified
                                      ? Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Email is not verified. ',
                                              style: TextStyle(
                                                color: Colors.black54,
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
                            SizedBox(height: 0.055 * screenSize.height),
                            Padding(
                              // padding: EdgeInsets.symmetric(horizontal: 3 * wm),
                              padding: EdgeInsets.symmetric(horizontal: 0.03 * screenSize.width),
                              child: signInButton(context, true),
                            ),
                            // SizedBox(height: 2 * hm),
                            SizedBox(height: 0.02 * screenSize.height),
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
                                      fontSize: 24.0,
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
                  height: 0.269578947 * screenSize.height,
                  width: double.infinity,
                  child: Image.asset('assets/img/profile.png'),
                ),
              ],
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.046 * screenSize.width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Lottie.asset(
                      'assets/animations/people-portrait.json',
                      height: 0.245 * screenSize.height,
                      width: 0.463 * screenSize.width,
                    ),
                  ),
                  SizedBox(height: 0.05 * screenSize.height),
                  Text(
                    'Oops!',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 7.5 * wm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.006 * screenSize.height),
                  Text(
                    'Looks like you are not logged in.',
                    style: TextStyle(
                      fontSize: 4.7 * wm,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  // SizedBox(height: 5 * hm),
                  SizedBox(height: 0.05 * screenSize.height),
                  Container(
                    // height:8 * hm,
                    height: 0.08 * screenSize.height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(11.58 * wm),
                    ),
                    child: signInButton(context, false),
                  ),
                  // SizedBox(height: 5 * hm),
                  SizedBox(height: 0.05 * screenSize.height),
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

  Widget signInButton(BuildContext context, bool isSignOut) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: Colors.grey[400],
        )
      ]),
      // height: 15 * wm,
      height: 0.077763158 * screenSize.height,
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
            FaIcon(
              FontAwesomeIcons.google,
              color: Colors.white,
              size: 5 * wm,
            ),
            // SizedBox(width: 2.6 * wm),
            SizedBox(width: 0.026 * screenSize.width),
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
                // Navigator.of(context).pushReplacementNamed('login_p');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }
            : () {
                _signOutAlert(context);
              },
      ),
    );
  }

  _signOutAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Please confirm your sign out.'),
          actions: [
            FlatButton(
              child: Text('Cancle'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Confirm"),
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                GoogleSignIn.standard().signOut();
                setState(() {});
                // prefsBox.isAnonymous = true;
                // prefsBox.save();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
