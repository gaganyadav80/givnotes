import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/pages/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:route_transitions/route_transitions.dart' as rt;
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

FirebaseUser currentUser;
String blankUser = 'assets/images/bank_User.png';
String photoUrl = blankUser, displayName = 'Not Logged in', email = '';

void setUserDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('url', currentUser.photoUrl);
  await prefs.setString('name', currentUser.displayName);
  await prefs.setString('email', currentUser.email);
}

Future<void> getUserDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  photoUrl = prefs.getString('url');
  displayName = prefs.getString('name');
  email = prefs.getString('email');
}

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

  currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  // !! persistent the userdetails
  setUserDetails();

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
            // !! SignInButton
            signInButton(context, onProfile: false, isSignOut: false),
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
                    setSkip(skip: true);
                    Navigator.push(
                      context,
                      rt.PageRouteTransition(
                        builder: (context) => NotesView(isTrash: false),
                        animationType: rt.AnimationType.slide_left,
                        curves: Curves.bounceOut,
                      ),
                    );
                    // TODO: Debug only, remove
                    // getSkip().then((value) {
                    //   print('pre value : $value isSkipped : $isSkipped');
                    //   setState(() {
                    //     isSkipped = value;
                    //   });
                    // });
                    // print('post isSkipped : $isSkipped');
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

Widget signInButton(BuildContext context, {bool onProfile, bool isSignOut}) {
  EdgeInsets marginCheck() {
    if (onProfile == false)
      return EdgeInsets.only(top: 50, bottom: 230);
    else
      return EdgeInsets.zero;
  }

  return Container(
    margin: marginCheck(),
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
            isSignOut == false ? 'Sign in' : 'Sign out',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      onPressed: isSignOut == false
          ? () {
              signInWithGoogle().then((FirebaseUser currentUser) {
                setSkip(skip: false);
                if (onProfile == true) setUserDetails();
                print('Sign in User Current : ${currentUser.displayName}');

                onProfile == true
                    ? Navigator.push(
                        context,
                        rt.PageRouteTransition(
                          builder: (context) => MyProfile(),
                          animationType: rt.AnimationType.fade,
                        ),
                      )
                    : Navigator.push(
                        context,
                        rt.PageRouteTransition(
                          builder: (context) => NotesView(isTrash: false),
                          animationType: rt.AnimationType.fade,
                        ),
                      );
              }).catchError((e) => print(e));
            }
          : () {
              _signOutAlert(context);
            },
    ),
  );
}

_signOutAlert(context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "SIGN OUT",
    desc: "Please confirm your sign out",
    buttons: [
      DialogButton(
        child: Text(
          "Confirm",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
        ),
        onPressed: () {
          signOutGoogle();
          logOut();
          setSkip(skip: true);
          Navigator.push(
            context,
            rt.PageRouteTransition(
              builder: (context) => LoginPage(),
              animationType: rt.AnimationType.slide_down,
            ),
          );
        },
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
      DialogButton(
        child: Text(
          "Cancle",
          style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Montserrat'),
        ),
        onPressed: () => Navigator.pop(context),
        gradient: LinearGradient(
            colors: [Color.fromRGBO(116, 116, 191, 1.0), Color.fromRGBO(52, 138, 199, 1.0)]),
      )
    ],
  ).show();
}
