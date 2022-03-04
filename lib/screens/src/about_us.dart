import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:givnotes/routes.dart';
import 'package:givnotes/widgets/blue_button.dart';

class AboutUsPage extends StatelessWidget {
  static const String aboutGivnotes =
      "Givnotes originated with the need for a notes app that is "
      "functional but also at the same time looks minimal and aesthetic. But wait, "
      "now you think you can name some apps which match this profile and even we "
      "can too, then why a new notes app? The answer is because you don't get it all. "
      "We tried some top applications in this field and fount out if some provided minimalistic "
      "app then functionality was missing or vice versa. If both then they didn't care more "
      "about your privacy by not encrypting your notes out-of-the-box.\n\n"
      "And at this point, we almost gave up which eventually motivated us to build something "
      "on our own, which lead to the origin of givnotes.";

  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25.0,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/logo/givnotes_logo.svg',
                alignment: Alignment.center,
                fit: BoxFit.contain,
                height: 120.w,
                width: 120.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Givnotes",
                    style: TextStyle(
                      fontSize: 36.w,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "by Giv Inc. Private Limited",
                    style: TextStyle(
                      fontSize: 14.0.w,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(aboutGivnotes),
                SizedBox(height: 30.0.h),
                Text(
                  "Where are my notes stored?",
                  style: TextStyle(
                    fontSize: 18.0.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0.h),
                const Text(
                  "Well for a starter we say it's your choice. Yes! you read it right. "
                  // "You can either use our servers which obviously encryptes your data before "
                  // "handing it over to us, or"
                  "You can use your choice of online cloud storage provider "
                  "which too will be encrypted, to sync and backup your notes.",
                ),
                SizedBox(height: 30.0.h),
                GestureDetector(
                  onTap: () => showLicensePage(
                    context: context,
                    applicationIcon: SvgPicture.asset(
                      'assets/logo/givnotes_logo.svg',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      height: 120.w,
                      width: 120.w,
                    ),
                    applicationName: "Givnotes",
                    applicationVersion: "v0.0.1-beta",
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "License",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0.w,
                        ),
                      ),
                      const Icon(CupertinoIcons.forward, color: Colors.blue),
                    ],
                  ),
                ),
                SizedBox(height: 30.0.h),
                BlueButton(
                    title: "Contact Us",
                    onPressed: () =>
                        Navigator.pushNamed(context, RouterName.contactRoute)),
                SizedBox(height: 50.0.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
