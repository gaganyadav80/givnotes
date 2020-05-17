import 'package:flutter/material.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';
import 'package:givnotes/utils/login.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  int count = 0;

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
    return Scaffold(
      drawer: DrawerItems(),
      appBar: MyAppBar(''),
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                CustomPaint(
                  size: Size(double.infinity, 120),
                  painter: LogoPainter(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 65, left: 20),
                  child: Container(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 33,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ),
                ),
              ],
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
                  backgroundImage: isSkipped == true
                      ? AssetImage(blankUser)
                      : NetworkImage(photoUrl),
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
              height: 65,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
              ),
              child: isSkipped == false
                  ? signInButton(context, onProfile: true, isSignOut: true)
                  : signInButton(context, onProfile: true, isSignOut: false),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
