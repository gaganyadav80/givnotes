import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/brandico_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:getwidget/getwidget.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.back, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Image.asset(
            "assets/img/contact_us.png",
            height: 300.0.w,
            width: 300.0.w,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.w),
                Text(
                  "How can we help you?",
                  style: TextStyle(
                    fontSize: 22.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.w),
                Text(
                  "It looks like you are experiencing problems "
                  "with our services. We are here to help "
                  "so please get in touch with us.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _contactTiles(CupertinoIcons.chat_bubble_2_fill,
                        "Chat to us", context),
                    _contactTiles(
                        CupertinoIcons.mail_solid, "Email us", context),
                  ],
                ),
                SizedBox(height: 30.w),
                Text(
                  "Follow us on",
                  style: TextStyle(
                    fontSize: 22.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _socialButtons(Brandico.instagram_1, () {}),
                    _socialButtons(FontAwesome5.twitter, () {}),
                    _socialButtons(FontAwesome5.basketball_ball, () {}),
                    _socialButtons(FontAwesome5.github, () {}),
                  ],
                ),
                SizedBox(height: 50.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final Color blueColor = const Color(0xff017CFD);

  SizedBox _socialButtons(IconData icon, Function onPressed) {
    return SizedBox(
      height: 60.w,
      width: 60.w,
      child: GFIconButton(
        onPressed: onPressed as void Function()?,
        color: blueColor,
        icon: Icon(icon),
        iconSize: 26.w,
      ),
    );
  }

  Material _contactTiles(IconData icon, String title, BuildContext context) {
    return Material(
      elevation: 8.0,
      shadowColor: Colors.grey[350],
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        height: 160.h,
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(15.r),
            onTap: () => ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                backgroundColor: blueColor,
                content: const Text("Will be added soon."),
              )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: blueColor,
                  size: 52.w,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.w,
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
