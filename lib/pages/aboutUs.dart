import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 76 * hm,
        padding: EdgeInsets.only(left: 2.3 * wm, right: 2.3 * wm),
        child: Stack(
          children: <Widget>[
            Divider(
              color: Colors.black,
              height: 3,
            ),
            Padding(
              padding: EdgeInsets.only(top: hm, left: 2.3 * wm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/logo/owlCute-transparent.png'),
                    height: 5.0 * hm,
                  ),
                  Text(
                    'Giv',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 2.2 * hm,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Notes.',
                    style: GoogleFonts.montserrat(
                      fontSize: 2.2 * hm,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.6 * hm, left: 2.3 * wm, right: 2.3 * wm),
              decoration: BoxDecoration(
                color: whiteIsh,
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
                    backgroundImage: AssetImage('assets/images/developer.png'),
                    backgroundColor: whiteIsh,
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
              padding: EdgeInsets.only(top: 21 * hm, left: 3 * wm),
              child: Text(
                'Liked My Work ... \nDon\'t forget to mention it :)',
                style: GoogleFonts.ubuntu(
                  fontSize: 3.4 * wm,
                ),
              ),
            ),
            Positioned(
              top: 18.5 * hm,
              left: 50 * wm,
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 12.5 * wm,
                  fontFamily: 'Abril',
                ),
              ),
            ),
            Positioned(
              top: 29.7 * hm,
              left: 1.5 * wm,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1.9 * wm),
                child: Image.asset(
                  'assets/images/share.png',
                  height: 22 * hm,
                  width: 58.5 * wm,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 27.5 * hm,
              left: 63 * wm,
              child: Container(
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
                        final String url = 'https://www.github.com/gaganyadav80/givnotes/';
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
            ),
            Container(
              margin: EdgeInsets.only(top: 57 * hm, left: 2.3 * wm, right: 2.3 * wm),
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
                  style: GoogleFonts.ubuntu(
                    fontSize: 1.8 * hm,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal[400],
                  ),
                ),
                subtitle: Text(
                  'Please let me know.',
                  style: TextStyle(
                    fontSize: 1.4 * hm,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 71 * hm,
              left: 29 * wm,
              child: Row(
                children: [
                  Icon(
                    Icons.copyright,
                    size: 4.5 * wm,
                  ),
                  Text(
                    '  Givnotes Inc.',
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.w500,
                      fontSize: 1.8 * hm,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
