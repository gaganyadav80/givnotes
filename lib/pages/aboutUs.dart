import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givnotes/ui/drawerItems.dart';
import 'package:givnotes/ui/homePageItems.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        appBar: myAppBar(''),
        body: Column(
          children: <Widget>[
            // CustomAppBar(''),
            Container(height: 10),
// *** Heading of the page
            Text(
              'ABOUT US',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 40,
                letterSpacing: 5,
              ),
            ),
// *** Name says it all
            Divider(
              color: Colors.black,
              endIndent: 60,
              indent: 60,
              thickness: 1,
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
                  // TODO: Change to a more professional picture
                  backgroundImage: AssetImage('assets/images/developer.JPEG'),
                ),
              ),
            ),
// *** Card for the Name
            Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 2),
              height: 280,
              width: 370,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 8,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
// *** Row to add the heart icon in between
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Made with "',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'SourceSansPro-Light',
                              letterSpacing: 5,
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.heart,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            '" by',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'SourceSansPro-Light',
                              letterSpacing: 5,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'GAGAN',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontFamily: 'SourceSansPro',
                          letterSpacing: 3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,
                          endIndent: 30,
                          indent: 30,
                        ),
                      ),
                      Text(
                        'APP DEVELOPER',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          letterSpacing: 5,
                          fontFamily: 'SourceSansPro-Light',
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.only(top: 5, left: 5),
                        leading: Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 26,
                        ),
                        title: Text(
                          'gaganyadav80@gmail.com',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SourceSansPro-Light',
                            fontSize: 24.0,
                            letterSpacing: 0.75,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomMenu(),
      ),
    );
  }
}
