import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
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
      child: SingleChildScrollView(
        child: Container(
          height: 620,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/aboutBack.png'),
            ),
          ),
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Stack(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Giv',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Notes.',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 70, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: whiteIsh,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(3),
                  // border: Border.all(),
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
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/developer.JPEG'),
                      backgroundColor: whiteIsh,
                      radius: 25,
                    ),
                  ),
                  title: Text(
                    'Gagan Yadav',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '~\$ Developer',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 170, left: 20),
                child: Text(
                  'Liked My Work ... \nDon\'t forget to mention it :)',
                  style: GoogleFonts.ubuntuMono(
                    fontSize: 20,
                  ),
                ),
              ),
              Positioned(
                top: 155,
                left: 330,
                child: Text(
                  '?',
                  style: TextStyle(
                    fontSize: 75,
                    fontFamily: 'Abril',
                  ),
                ),
              ),
              Positioned(
                top: 260,
                left: 24,
                child: Image(
                  image: AssetImage('assets/images/mention.png'),
                  height: 180,
                  width: 240,
                ),
              ),
              Positioned(
                top: 265,
                left: 284,
                child: Column(
                  children: <Widget>[
                    GFButton(
                      onPressed: () async {
                        final String url = 'https://www.twitter.com/gagan_yadav_47';
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
                        size: 20,
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
                        size: 20,
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
                      splashColor: Colors.black,
                      color: Colors.blue[900],
                      type: GFButtonType.outline,
                      shape: GFButtonShape.standard,
                      text: 'Facebook ',
                      icon: Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.blue[900],
                        size: 20,
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
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              // TODO: remove it
              // Positioned(
              //   top: 237,
              //   left: 364,
              //   child: Text(
              //     '___\n   |\n   |\n   |\n   |\n   |\n   |\n___|',
              //     style: GoogleFonts.ubuntuMono(
              //       fontSize: 25,
              //     ),
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(top: 510, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: whiteIsh,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(3),
                  // border: Border.all(),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    CupertinoIcons.conversation_bubble,
                    size: 45,
                    color: Colors.greenAccent,
                  ),
                  title: Text(
                    'Found something strange?',
                    style: GoogleFonts.ubuntuMono(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.greenAccent,
                    ),
                  ),
                  subtitle: Text(
                    'Please let me know.',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
