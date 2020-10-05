import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/utils/login.dart';
import 'package:givnotes/utils/permissions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:givnotes/variables/prefs.dart' as prefs;

// !! Login Page Design
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.none:
          setState(() => isConnected = false);
          break;
        default:
          setState(() => isConnected = true);
          break;
      }
    });
    // getFirstLauch().then((value) => isFirstLaunch = value);
  }

  // void netCheck() async {
  // try {
  //   final result = await InternetAddress.lookup('google.com');
  //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //     setState(() {
  //       isConnected = true;
  //     });
  //   }
  // } on SocketException catch (_) {
  //   setState(() {
  //     isConnected = false;
  //   });
  // }
  // }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 3 * wm, right: 3 * wm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 7 * hm),
              Row(
                children: <Widget>[
                  Text(
                    'Giv',
                    style: GoogleFonts.ubuntu(
                      fontSize: 2.5 * hm,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Notes.',
                    style: GoogleFonts.ubuntu(
                      fontSize: 2.5 * hm,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5 * hm),
              Image.asset(
                'assets/images/growth.png',
                width: double.infinity,
              ),
              SizedBox(height: 5 * hm),
              Text(
                'Sign in',
                style: GoogleFonts.ubuntu(
                  fontSize: 4 * hm,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 0.8 * hm),
              Text(
                'Please sign in to sync.',
                style: GoogleFonts.ubuntu(
                  fontSize: 2 * hm,
                  color: toastGrey,
                ),
              ),
              // !! SignInButton
              SizedBox(height: 4 * hm),
              signInButton(context, onProfile: false, isSignOut: false),
              SizedBox(height: 3.7 * hm),

              Center(
                child: Text(
                  "Don't feel like syncing?",
                  style: GoogleFonts.ubuntu(
                    color: Color(0xffaab7bb),
                    fontSize: 1.8 * hm,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: hm / 1.5),
              Center(
                child: Container(
                  width: 30 * wm,
                  child: GFButton(
                    size: 11 * wm,
                    splashColor: Colors.black,
                    icon: FaIcon(
                      FontAwesomeIcons.userSlash,
                      size: 1.6 * hm,
                      color: Colors.black,
                    ),
                    type: GFButtonType.outline2x,
                    color: Colors.black,
                    text: 'Skip',
                    textStyle: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 2 * hm,
                      fontWeight: FontWeight.w400,
                    ),
                    onPressed: () async {
                      await HandlePermission().requestPermission();
                      // setSkip(skip: true);
                      // setFirstLaunch(isFirstLaunch: false);
                      prefsBox.put('skip', true);
                      prefsBox.put('firstLaunch', false);

                      Navigator.push(
                        context,
                        PageRouteTransition(
                          builder: (context) => HomePage(),
                          animationType: AnimationType.fade,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: hm),
              if (isConnected == false && isFirstLaunch == true)
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.ubuntu(
                        color: Color(0xffaab7bb),
                        fontSize: 1.6 * hm,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '* Note:- Please be connected to the internet\n',
                        ),
                        TextSpan(text: '          We need it, to load custom fonts\n'),
                        TextSpan(text: '          ( One time thing only, I promise )')
                      ],
                    ),
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
        blurRadius: 8,
        color: Colors.grey[400],
      )
    ]),
    height: 15 * wm,
    child: GFButton(
      elevation: 2,
      fullWidthButton: true,
      color: onProfile == true ? Colors.black : Colors.red[400],
      borderShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3 * wm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.google,
            color: Colors.white,
            size: 2.2 * hm,
          ),
          SizedBox(width: 2.6 * wm),
          Text(
            isSignOut == false ? 'Sign in' : 'Sign out',
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: 3 * hm,
            ),
          ),
        ],
      ),
      onPressed: isSignOut == false
          ? () {
              signInWithGoogle().then((value) async {
                // setSkip(skip: false);
                prefsBox.put('skip', false);
                // if (onProfile == true) setUserDetails();
                await HandlePermission().requestPermission();

                Navigator.push(
                  context,
                  PageRouteTransition(
                    builder: (context) => HomePage(),
                    animationType: AnimationType.fade,
                  ),
                );
              }).catchError((e) => prefs.errorAlert(context, e));
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
        // title: Text('Sign Out?'),
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
              // setSkip(skip: true);
              prefsBox.put('skip', true);
              Navigator.push(
                context,
                PageRouteTransition(
                  builder: (context) => LoginPage(),
                  animationType: AnimationType.fade,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
