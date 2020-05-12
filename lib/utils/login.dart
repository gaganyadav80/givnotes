import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/pages/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Map<String, String> details = {
  'displayName': '',
  'photoUrl': '',
  'phone': '',
  'email': '',
  'providerId': '',
  'uid': '',
};

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  details['displayName'] = currentUser.displayName;
  details['photoUrl'] = currentUser.photoUrl;
  details['phone'] = currentUser.phoneNumber;
  details['email'] = currentUser.email;
  details['providerId'] = currentUser.providerId;
  details['uid'] = currentUser.uid;

  print('currentUser succeeded: ${currentUser.displayName}');
  return currentUser;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("User Sign Out");
}

Future<void> logOut() async {
  try {
    await _auth.signOut();
  } catch (e) {
    print("\nerror logging out\n");
  }
}

// !! Login Page Design
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 80, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Giv',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Notes.',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
            Text(
              'Sign in',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Please sign in to sync.',
              style: TextStyle(
                color: darkGrey,
                fontFamily: 'Montserrat',
                fontSize: 16,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 200),
              height: 65,
              child: GFButton(
                elevation: 4,
                fullWidthButton: true,
                // color: Color(0xff91dcf5),
                color: lightBlue,
                borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 21,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 22,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  signInWithGoogle().then((FirebaseUser currentUser) {
                    isSkipped = false;
                    print('Sign in User Current : $currentUser');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return HomePage();
                    }));
                  }).catchError((e) => print(e));
                },
              ),
            ),
            Center(
              child: Text(
                "Don't feel like syncing?",
                style: TextStyle(
                  color: Color(0xffaab7bb),
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 170,
                child: GFButton(
                  size: 50,
                  icon: FaIcon(
                    FontAwesomeIcons.userSlash,
                    size: 16,
                    color: Color(0xff54B7E2),
                  ),
                  type: GFButtonType.outline2x,
                  color: Color(0xff54B7E2),
                  text: 'Skip',
                  textStyle: TextStyle(
                    color: Color(0xff54B7E2),
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                  onPressed: () {
                    isSkipped = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    print('isSkipped : $isSkipped');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Scaffold(
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
//               height: 60,
//               width: 370,
//               decoration: BoxDecoration(
//                   color: Colors.black,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.circular(5)),
//               margin: EdgeInsets.only(top: 30),
//               child: Text(
//                 'WELCOME TO GIV NOTES',
//                 style: TextStyle(
//                   fontFamily: 'SourceSansPro',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 27,
//                   letterSpacing: 3,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Divider(
//               color: Colors.black,
//               thickness: 0.5,
//               indent: 40,
//               endIndent: 40,
//             ),
//             Container(
//               margin: EdgeInsets.all(20),
//               child: Text(
//                 'Please Login with your Google account to sync.\nOr Skip',
//                 style: TextStyle(
//                   fontFamily: 'SourceSansPro',
//                   fontSize: 20,
//                   letterSpacing: 3,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Container(
//               color: Colors.black,
//               margin: EdgeInsets.only(top: 20),
//               height: 200,
//               width: 200,
//               child: Card(
//                 elevation: 20,
//                 child: Image(
//                   image: AssetImage('assets/logo/icons/0001-1.jpg'),
//                 ),
//               ),
//             ),
//             SizedBox(height: 50),
//             // _signInButton(),
//             Container(
//               height: 60,
//               width: 200,
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: GFButton(
//                 elevation: 10,
//                 buttonBoxShadow: true,
//                 color: Colors.black,
//                 text: '  Google',
//                 icon: FaIcon(
//                   FontAwesomeIcons.googlePlusG,
//                   color: Colors.white,
//                 ),
//                 textStyle: TextStyle(
//                   fontSize: 25,
//                   fontFamily: 'SourceSansPro',
//                   letterSpacing: 3,
//                 ),
//                 type: GFButtonType.solid,
//                 size: GFSize.LARGE,
//                 shape: GFButtonShape.standard,
//                 padding: EdgeInsets.all(10),
//                 fullWidthButton: true,
//                 onPressed: () {
//                   signInWithGoogle().then((FirebaseUser currentUser) {
//                     isSkipped = false;
//                     print('Sign in User Current : $currentUser');
//                     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                       return HomePage();
//                     }));
//                   }).catchError((e) => print(e));
//                 },
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(top: 15),
//               height: 60,
//               width: 200,
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: GFButton(
//                 elevation: 10,
//                 buttonBoxShadow: true,
//                 color: Colors.black,
//                 text: '   Skip    ',
//                 icon: FaIcon(
//                   FontAwesomeIcons.solidArrowAltCircleRight,
//                   color: Colors.white,
//                 ),
//                 textStyle: TextStyle(
//                   fontSize: 25,
//                   fontFamily: 'SourceSansPro',
//                   letterSpacing: 3,
//                 ),
//                 type: GFButtonType.solid,
//                 size: GFSize.LARGE,
//                 shape: GFButtonShape.standard,
//                 padding: EdgeInsets.all(10),
//                 fullWidthButton: true,
//                 onPressed: () {
//                   isSkipped = true;
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => HomePage()),
//                   );
//                   print('isSkipped : $isSkipped');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
