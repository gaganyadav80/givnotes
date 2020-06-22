import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/utils/login.dart';
import 'package:givnotes/utils/permissions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';

// !! Login Page Design
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    netCheck();
    getFirstLauch().then((value) => isFirstLaunch = value);
  }

  void netCheck() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 17 * hm, left: 4 * wm, right: 4 * wm),
                child: Image.asset(
                  'assets/images/growth.png',
                  height: 27 * hm,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.6 * wm, right: 4.6 * wm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 7 * hm),
                    Row(
                      children: <Widget>[
                        Text(
                          'Giv',
                          style: GoogleFonts.ubuntu(
                            fontSize: 2.2 * hm,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Notes.',
                          style: GoogleFonts.ubuntu(
                            fontSize: 2.2 * hm,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40 * hm),
                    Text(
                      'Sign in',
                      style: GoogleFonts.ubuntu(
                        fontSize: 3.8 * hm,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 0.8 * hm),
                    Text(
                      'Please sign in to sync.',
                      style: GoogleFonts.ubuntu(
                        fontSize: 1.8 * hm,
                        color: darkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 6.1 * hm),
                    // !! SignInButton
                    signInButton(context, onProfile: false, isSignOut: false),
                    SizedBox(height: 3.7 * hm),
                    Center(
                      child: Text(
                        "Don't feel like syncing?",
                        style: GoogleFonts.ubuntu(
                          color: Color(0xffaab7bb),
                          fontSize: 1.6 * hm,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.2 * hm),
                    Center(
                      child: Container(
                        width: 33 * wm,
                        child: GFButton(
                          size: hm < 6.5 ? 7 * hm : 5.5 * hm,
                          icon: FaIcon(
                            FontAwesomeIcons.userSlash,
                            size: 1.8 * hm,
                            color: Color(0xff5A56D0),
                          ),
                          type: GFButtonType.outline2x,
                          color: Color(0xff5A56D0),
                          text: 'Skip',
                          textStyle: GoogleFonts.ubuntu(
                            color: Color(0xff5A56D0),
                            fontSize: 2.2 * hm,
                            fontWeight: FontWeight.w400,
                          ),
                          onPressed: () async {
                            await HandlePermission().requestPermission();
                            setSkip(skip: true);
                            setFirstLaunch(isFirstLaunch: false);

                            Navigator.push(
                              context,
                              PageRouteTransition(
                                builder: (context) => HomePage(),
                                animationType: AnimationType.slide_right,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 4.4 * hm),
                    if (isConnected == false && isFirstLaunch == true)
                      Center(
                        child: Text(
                          '* Note:- Please be connected to the internet',
                          style: GoogleFonts.ubuntu(
                            color: Color(0xffaab7bb),
                            fontSize: 1.4 * hm,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    if (isConnected == false && isFirstLaunch == true)
                      Center(
                        child: Text(
                          'We need it, to load custom fonts',
                          style: GoogleFonts.ubuntu(
                            color: Color(0xffaab7bb),
                            fontSize: 1.4 * hm,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    if (isConnected == false && isFirstLaunch == true)
                      Center(
                        child: Text(
                          '( One time thing only, I promise )',
                          style: GoogleFonts.ubuntu(
                            color: Color(0xffaab7bb),
                            fontSize: 1.4 * hm,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget signInButton(BuildContext context, {bool onProfile, bool isSignOut}) {
  return Container(
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        blurRadius: 10,
        color: Colors.grey[400],
      )
    ]),
    height: hm < 7 ? 9 * hm : 8 * hm,
    child: GFButton(
      elevation: 4,
      fullWidthButton: true,
      color: onProfile == true ? Colors.black : purple,
      borderShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3 * wm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.google,
            color: Colors.white,
            size: onProfile ? 2.2 * hm : 2.5 * hm,
          ),
          SizedBox(width: 4.6 * wm),
          Text(
            isSignOut == false ? 'Sign in' : 'Sign out',
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: onProfile ? 2.5 * hm : 2.9 * hm,
            ),
          ),
        ],
      ),
      onPressed: isSignOut == false
          ? () {
              signInWithGoogle().then((value) async {
                setSkip(skip: false);
                // if (onProfile == true) setUserDetails();
                await HandlePermission().requestPermission();

                Navigator.push(
                  context,
                  PageRouteTransition(
                    builder: (context) => HomePage(),
                    animationType: onProfile ? AnimationType.fade : AnimationType.slide_down,
                  ),
                );
              }).catchError((e) => print(e));
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
        title: Text('Sign Out?'),
        content: Text('Please confirm your sign out.'),
        actions: [
          FlatButton(
            child: Text('Cancle'),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text("Confirm"),
            onPressed: () {
              signOutGoogle();
              logOut();
              setSkip(skip: true);
              Navigator.push(
                context,
                PageRouteTransition(
                  builder: (context) => LoginPage(),
                  animationType: AnimationType.slide_up,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

// getSkip().then((value) {
//   print('pre value : $value isSkipped : $isSkipped');
//   setState(() {
//     isSkipped = value;
//   });
// });
// print('post isSkipped : $isSkipped');
