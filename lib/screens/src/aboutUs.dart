import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:givnotes/screens/themes/app_themes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

//TODO not used
class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hm = context.percentHeight;
    final wm = context.percentWidth;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: GiveStatusBarColor(context),
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 25.0,
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.arrow_left, color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/logo/owlCute-transparent.png'),
                    height: 9.5 * wm,
                  ),
                  Text(
                    'Giv',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 4.5 * wm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Notes.',
                    style: TextStyle(
                      fontSize: 4.5 * wm,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                // margin: EdgeInsets.only(top: 4 * hm),
                decoration: BoxDecoration(
                  color: Color(0xffFAFAFA),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.8 * wm),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/img/developer.png'),
                      backgroundColor: Color(0xffFAFAFA),
                      radius: 5.8 * wm,
                    ),
                  ),
                  title: Text(
                    'Gagan Yadav',
                    style: TextStyle(
                      fontSize: 4.0 * wm,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '~\$ Developer  (bish)',
                    style: TextStyle(
                      fontSize: 3 * wm,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0 * hm),
                child: Row(
                  children: [
                    Text(
                      'Liked My Work ... \nDon\'t forget to mention it :)',
                      style: TextStyle(
                        fontSize: 4 * wm,
                      ),
                    ),
                    SizedBox(width: 2 * wm),
                    Text(
                      '?',
                      style: TextStyle(
                        fontSize: 12.5 * wm,
                        fontFamily: 'Abril',
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 2 * hm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/img/share.png',
                      height: 25 * hm,
                      width: 58.5 * wm,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Container(
                    width: 30 * wm,
                    child: Column(
                      children: <Widget>[
                        GFButton(
                          onPressed: () async {
                            final String url = 'https://www.twitter.com/_yadavGagan';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not open Twitter profile';
                            }
                          },
                          splashColor: Colors.blue,
                          color: Colors.blue,
                          type: GFButtonType.outline,
                          shape: GFButtonShape.standard,
                          text: 'Twitter     ',
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Colors.blue,
                            size: 2.5 * hm,
                          ),
                        ),
                        GFButton(
                          onPressed: () async {
                            final String url = 'https://www.instagram.com/gagan.yadav.80';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not open Instagram profile';
                            }
                          },
                          splashColor: Colors.pink[600],
                          color: Colors.pink[600],
                          type: GFButtonType.outline,
                          shape: GFButtonShape.standard,
                          text: 'Instagram',
                          icon: Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.pink[600],
                            size: 2.5 * hm,
                          ),
                        ),
                        GFButton(
                          onPressed: () async {
                            final String url = 'https://www.facebook.com/gagan.77492';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not open Facebook profile';
                            }
                          },
                          splashColor: Colors.blue[900],
                          color: Colors.blue[900],
                          type: GFButtonType.outline,
                          shape: GFButtonShape.standard,
                          text: 'Facebook ',
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.blue[900],
                            size: 2.5 * hm,
                          ),
                        ),
                        GFButton(
                          onPressed: () async {
                            final String url = 'https://www.github.com/gaganyadav80/givnotes/issues';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not open Github profile';
                            }
                          },
                          splashColor: Colors.black,
                          color: Colors.black,
                          type: GFButtonType.outline,
                          shape: GFButtonShape.standard,
                          text: 'Github       ',
                          icon: Icon(
                            FontAwesomeIcons.github,
                            color: Colors.black,
                            size: 2.5 * hm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 3 * hm),
              Container(
                padding: EdgeInsets.only(top: 0, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    CupertinoIcons.conversation_bubble,
                    size: 9.5 * wm,
                    color: Colors.teal[400],
                  ),
                  title: Text(
                    'Found something strange?',
                    style: TextStyle(
                      fontSize: 1.8 * hm,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal[400],
                    ),
                  ),
                  subtitle: Text(
                    'Please let me know.\nUse one of the social links to report',
                    style: TextStyle(
                      fontSize: 1.4 * hm,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3 * wm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copyright,
                      size: 4.5 * wm,
                    ),
                    Text(
                      '  Givnotes Inc.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 3.6 * wm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
