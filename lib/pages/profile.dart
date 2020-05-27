import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/loginPage.dart';
import 'package:givnotes/utils/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int count = 0;

  @override
  void initState() {
    getSkip().then((bool skip) {
      setState(() {
        isSkipped = skip ?? false;
        getUserDetails();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: isSkipped == true
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 210),
                      child: Lottie.asset(
                        blankUser,
                        height: 200,
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Oops!',
                      style: GoogleFonts.montserrat(
                        color: Colors.teal,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Looks like you are not logged in.',
                      style: GoogleFonts.sourceSansPro(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 100),
                    Container(
                      height: 65,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: signInButton(context, onProfile: true, isSignOut: false),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      height: 270,
                      width: double.infinity,
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 70),
                              Text(
                                displayName,
                                style: GoogleFonts.arizonia(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                email,
                                style: GoogleFonts.sourceSansPro(
                                  color: Colors.black54,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 65,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: signInButton(context, onProfile: true, isSignOut: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 30,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundImage: cachePhoto,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 300),
                      height: 300,
                      width: double.infinity,
                      child: Image.asset('assets/images/chatting.png'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
