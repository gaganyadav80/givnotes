import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:givnotes/utils/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    getSkip().then((bool skip) {
      print('pre value: $skip and isSkipped: $isSkipped');
      setState(() {
        isSkipped = skip ?? false;
        getUserDetails();
      });
      print('post value: $skip and isSkipped: $isSkipped');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        appBar: MyAppBar('MY PROFILE'),
        body: Center(
          child: Column(
            children: <Widget>[
              // CustomAppBar('MY PROFILE'),
              SizedBox(
                height: 40,
              ),
              // *** Developer aka Me profile pic
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: Colors.black),
                ),
                child: Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  elevation: 8,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        isSkipped == true ? NetworkImage(blankUser) : NetworkImage(photoUrl),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                isSkipped == true ? 'Not Logged in' : displayName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Montserrat',
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                isSkipped == true ? '' : email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'SourceSansPro',
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 40),
              Container(
                height: 50,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: isSkipped == false
                    ? MaterialButton(
                        color: Colors.white,
                        elevation: 10,
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          _signOutAlert(context);
                        },
                      )
                    : MaterialButton(
                        color: Colors.black,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          signInWithGoogle().then((FirebaseUser currentUser) {
                            print('Sign in User Current : ${currentUser.displayName}');
                            setUserDetails();
                            setSkip(skip: false);
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => MyProfile()));
                          }).catchError((e) => print(e));
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomMenu(),
      ),
    );
  }
}

// ! Alert dialog to let the user signout
_signOutAlert(context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "SIGN OUT",
    desc: "Please confirm your sign out",
    buttons: [
      DialogButton(
        child: Text(
          "Confirm",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
        ),
        onPressed: () {
          signOutGoogle();
          logOut();
          setSkip(skip: true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyProfile()),
          );
        },
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "Cancle",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(
            colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
      )
    ],
  ).show();
}
