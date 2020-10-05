import 'package:firebase_auth/firebase_auth.dart';
import 'package:givnotes/variables/prefs.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
GoogleSignInAccount googleSignInAccount;

FirebaseUser currentUser;
// String blankUser = 'assets/animations/people-portrait.json';
// String photoUrl = '', displayName = 'Not Logged in', email = '';

Map<dynamic, dynamic> userDetails;
//  = {'url': '', 'name': 'Not Logged in', 'email': ''};

Future<void> setUserDetails() async {
  await prefsBox.put('user', {
    'url': currentUser.photoUrl,
    'name': currentUser.displayName,
    'email': currentUser.email,
  });

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setString('url', currentUser.photoUrl);
  // await prefs.setString('name', currentUser.displayName);
  // await prefs.setString('email', currentUser.email);
}

Future<void> getUserDetails() async {
  userDetails = await prefsBox.get('user') as Map;

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // photoUrl = prefs.getString('url');
  // displayName = prefs.getString('name');
  // email = prefs.getString('email');
}

Future<FirebaseUser> signInWithGoogle() async {
  final GoogleSignInAccount gSA = await googleSignIn.signIn();
  googleSignInAccount = gSA;
  final GoogleSignInAuthentication googleSignInAuthentication = await gSA.authentication;

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
  await setUserDetails();
  getUserDetails();

  print('currentUser succeeded: ${currentUser.displayName}');
  return currentUser;
}

void signOutGoogle() async {
  await googleSignIn.signOut();
}

Future<void> logOut() async {
  try {
    await _auth.signOut();
  } catch (e) {
    print("\nerror logging out\n");
  }
}
