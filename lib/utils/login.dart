import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

FirebaseUser currentUser;
String blankUser = 'assets/animations/people-portrait.json';
String photoUrl = '', displayName = 'Not Logged in', email = '';

Future<void> setUserDetails() async {
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
  await setUserDetails();

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
