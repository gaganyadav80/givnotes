import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/utils/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:route_transitions/route_transitions.dart' as rt;

// !! Login Page Design
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 0, right: 20),
                child: Image.asset(
                  'assets/images/growth.jpg',
                  height: 350,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 70),
                    Row(
                      children: <Widget>[
                        Text(
                          'Giv',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Notes.',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 290),
                    Text(
                      'Sign in',
                      style: GoogleFonts.montserrat(
                        fontSize: 35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please sign in to sync.',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: darkGrey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 50),
                    // !! SignInButton
                    signInButton(context, onProfile: false, isSignOut: false),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Don't feel like syncing?",
                        style: GoogleFonts.montserrat(
                          color: Color(0xffaab7bb),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 170,
                        child: GFButton(
                          size: 50,
                          icon: FaIcon(
                            FontAwesomeIcons.userSlash,
                            size: 16,
                            color: Color(0xff5A56D0),
                          ),
                          type: GFButtonType.outline2x,
                          color: Color(0xff5A56D0),
                          text: 'Skip',
                          textStyle: GoogleFonts.montserrat(
                            color: Color(0xff5A56D0),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                          onPressed: () {
                            setSkip(skip: true);
                            Navigator.push(
                              context,
                              rt.PageRouteTransition(
                                builder: (context) => HomePage(),
                                animationType: rt.AnimationType.slide_right,
                              ),
                            );
                          },
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
    height: 65,
    child: GFButton(
      elevation: 4,
      fullWidthButton: true,
      color: onProfile == true ? Colors.black : purple,
      borderShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.google,
            color: Colors.white,
            size: 22,
          ),
          SizedBox(width: 20),
          Text(
            isSignOut == false ? 'Sign in' : 'Sign out',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              // fontWeight: FontWeight.w500,
              fontSize: 25,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      onPressed: isSignOut == false
          ? () {
              signInWithGoogle().then((value) {
                setSkip(skip: false);
                if (onProfile == true) setUserDetails();

                Navigator.push(
                  context,
                  rt.PageRouteTransition(
                    builder: (context) => HomePage(),
                    animationType: onProfile ? rt.AnimationType.fade : rt.AnimationType.slide_down,
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

_signOutAlert(context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "SIGN OUT",
    desc: "Please confirm your sign out",
    buttons: [
      DialogButton(
        child: Text(
          "Cancle",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(
            colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
      ),
      DialogButton(
        child: Text(
          "Confirm",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () {
          signOutGoogle();
          logOut();
          setSkip(skip: true);
          Navigator.push(
            context,
            rt.PageRouteTransition(
              builder: (context) => LoginPage(),
              animationType: rt.AnimationType.slide_up,
            ),
          );
        },
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
    ],
  ).show();
}

// TODO: Debug only, remove
// getSkip().then((value) {
//   print('pre value : $value isSkipped : $isSkipped');
//   setState(() {
//     isSkipped = value;
//   });
// });
// print('post isSkipped : $isSkipped');
