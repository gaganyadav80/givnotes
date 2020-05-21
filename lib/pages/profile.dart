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
        backgroundColor: Colors.white,
      drawer: DrawerItems(),
      appBar: MyAppBar(''),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            CustomPaint(
              size: Size(double.infinity, 120),
              painter: LogoPainter(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60, right: 250),
              child: Container(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Color(0xff252644),
                    fontSize: 40,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
            ),
            // *** Developer aka Me profile pic
            Container(
              margin: EdgeInsets.only(top: 190, left: 10, right: 10),
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                // color: Color(0xffEC625C)
                color: Color(0xffFAFAFA),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 15,
                  ),
                ],
              ),
              height: 360,
              width: 380,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 130),
                  Text(
                    isSkipped == true ? 'Not Logged in' : displayName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'Arizonia',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    isSkipped == true ? 'gaganyadav80@gmail.com' : email,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontFamily: 'Averia',
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 65),
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
            Positioned(
              top: 100,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1.5,
                    color: Color(0xffE67D6A),
                  ),
                ),
                child: Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  elevation: 5,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        isSkipped == true ? AssetImage(blankUser) : NetworkImage(photoUrl),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ActionBarMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomMenu(),
    );
  }
}
