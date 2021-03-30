import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/brandico_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:givnotes/screens/themes/app_themes.dart';

class ContactGivnotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: giveStatusBarColor(context),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.arrow_left, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Image.asset(
            "assets/img/contact_us.png",
            height: 320.0,
            width: 320.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                Text(
                  "How can we help you?",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "It looks like you are experiencing problems "
                  "with our services. We are here to help "
                  "so please get in touch with us.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _contactTiles(CupertinoIcons.chat_bubble_2_fill, "Chat to us", context),
                    _contactTiles(CupertinoIcons.mail_solid, "Email us", context),
                  ],
                ),
                SizedBox(height: 30.0),
                Text(
                  "Follow us on",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _socialButtons(Brandico.instagram_1, () {}),
                    _socialButtons(FontAwesome5.twitter, () {}),
                    _socialButtons(FontAwesome5.basketball_ball, () {}),
                    _socialButtons(FontAwesome5.github, () {}),
                  ],
                ),
                SizedBox(height: 50.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final Color blueColor = Color(0xff017CFD);

  Container _socialButtons(IconData icon, Function onPressed) {
    return Container(
      height: 60.0,
      width: 60.0,
      child: GFIconButton(
        onPressed: onPressed,
        color: blueColor,
        icon: Icon(icon),
        iconSize: 26.0,
      ),
    );
  }

  Material _contactTiles(IconData icon, String title, BuildContext context) {
    return Material(
      elevation: 8.0,
      shadowColor: Colors.grey[350],
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        height: 160.0,
        width: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () => ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                backgroundColor: blueColor,
                content: Text("Will be added soon."),
              )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: blueColor,
                  size: 52.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
