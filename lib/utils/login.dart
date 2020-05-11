import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/pages/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// TODO: pass the firebase user to display profile and table
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
FirebaseUser user;

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  // final FirebaseUser user = authResult.user;
  user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                height: 60,
                width: 370,
                decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5)),
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  'WELCOME TO GIV NOTES',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    letterSpacing: 3,
                    color: Colors.white,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.5,
                indent: 40,
                endIndent: 40,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  'Please Login with your Google account to sync.\nOr Skip',
                  style: TextStyle(
                    fontFamily: 'SourceSansPro',
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                margin: EdgeInsets.only(top: 20),
                height: 200,
                width: 200,
                child: Card(
                  elevation: 20,
                  child: Image(
                    image: AssetImage('assets/logo/icons/0001-1.jpg'),
                  ),
                ),
              ),
              SizedBox(height: 50),
              // _signInButton(),
              Container(
                height: 60,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GFButton(
                  elevation: 10,
                  buttonBoxShadow: true,
                  color: Colors.black,
                  text: '  Google',
                  icon: FaIcon(
                    FontAwesomeIcons.googlePlusG,
                    color: Colors.white,
                  ),
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontFamily: 'SourceSansPro',
                    letterSpacing: 3,
                  ),
                  type: GFButtonType.solid,
                  size: GFSize.LARGE,
                  shape: GFButtonShape.standard,
                  padding: EdgeInsets.all(10),
                  fullWidthButton: true,
                  onPressed: () {
                    signInWithGoogle().then((FirebaseUser currentUser) {
                      print('Sign in User Current : $currentUser');
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }));
                    }).catchError((e) => print(e));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                height: 60,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GFButton(
                  elevation: 10,
                  buttonBoxShadow: true,
                  color: Colors.black,
                  text: '   Skip    ',
                  icon: FaIcon(
                    FontAwesomeIcons.solidArrowAltCircleRight,
                    color: Colors.white,
                  ),
                  textStyle: TextStyle(
                    fontSize: 25,
                    fontFamily: 'SourceSansPro',
                    letterSpacing: 3,
                  ),
                  type: GFButtonType.solid,
                  size: GFSize.LARGE,
                  shape: GFButtonShape.standard,
                  padding: EdgeInsets.all(10),
                  fullWidthButton: true,
                  onPressed: () {
                    isSkipped = true;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
