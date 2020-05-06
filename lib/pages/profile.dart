import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:givnotes/utils/login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyProfile extends StatelessWidget {
  final String name = 'Gagan';

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
                    backgroundImage: AssetImage('assets/images/developer.JPEG'),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Current User: ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'SourceSansPro',
                  letterSpacing: 2,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'SourceSansPro',
                  letterSpacing: 2,
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
                child: GFButton(
                  elevation: 10,
                  buttonBoxShadow: true,
                  color: Colors.white,
                  icon: Icon(
                    Icons.warning,
                    color: Colors.black,
                  ),
                  text: ' Sign Out',
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontFamily: 'SourceSansPro',
                    letterSpacing: 3,
                    color: Colors.black,
                  ),
                  type: GFButtonType.solid,
                  size: GFSize.LARGE,
                  shape: GFButtonShape.standard,
                  padding: EdgeInsets.all(10),
                  fullWidthButton: true,
                  onPressed: () {
                    _signOutAlert(context);
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
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          signOutGoogle();
          logOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "Cancle",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(
            colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
      )
    ],
  ).show();
}
