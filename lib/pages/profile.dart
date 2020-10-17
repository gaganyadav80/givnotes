import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givnotes/variables/homeVariables.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:givnotes/pages/loginPage.dart';
import 'package:givnotes/utils/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    setState(() {
      isSkipped = prefsBox.get('skip') ?? false;
      // getUserDetails();
    });
    // getSkip().then((bool skip) {
    //   setState(() {
    //     isSkipped = skip ?? false;
    //     getUserDetails();
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isSkipped == true
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.6 * wm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 48.6 * wm),
                    child: Lottie.asset(
                      'assets/animations/people-portrait.json',
                      height: 24.5 * hm,
                      width: 46.3 * wm,
                    ),
                  ),
                  SizedBox(height: 5 * hm),
                  Text(
                    'Oops!',
                    style: GoogleFonts.ubuntu(
                      color: Colors.teal,
                      fontSize: 7.5 * wm,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.6 * hm),
                  Text(
                    'Looks like you are not logged in.',
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 4.7 * wm,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 5 * hm),
                  Container(
                    height: 8 * hm,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(11.58 * wm),
                    ),
                    child: signInButton(context, onProfile: true, isSignOut: false),
                  ),
                  SizedBox(height: 5 * hm),
                  Text(
                    'Not much here, yet. Maybe I\'ll add later.',
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                      fontSize: 1.8 * hm,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5 * wm),
                  child: Stack(
                    children: <Widget>[
                      Card(
                        margin: EdgeInsets.only(top: 8 * hm),
                        elevation: 1 * hm,
                        shadowColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.63 * wm),
                        ),
                        // *Profile Card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 14 * wm),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7 * wm),
                              child: Text(
                                userDetails['name'],
                                style: GoogleFonts.arizonia(
                                  color: Colors.black,
                                  fontSize: 4 * hm,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.12 * wm,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7 * wm),
                              child: Text(
                                userDetails['email'],
                                style: GoogleFonts.sourceSansPro(
                                  color: Colors.black54,
                                  fontSize: 2.2 * hm,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.5 * hm),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3 * wm),
                              child: signInButton(context, onProfile: true, isSignOut: true),
                            ),
                            SizedBox(height: 2 * hm),
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
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) => FaIcon(FontAwesomeIcons.unlink),
                                placeholder: (context, url) => CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                                imageUrl: userDetails['url'],
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // height: 27 * hm,
                  height: 52 * wm,
                  width: double.infinity,
                  child: Image.asset('assets/images/profile.png'),
                ),
              ],
            ),
    );
  }
}
