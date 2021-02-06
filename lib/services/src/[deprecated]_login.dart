// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;
// final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata']);
// GoogleSignInAccount googleSignInAccount;

// // Future<bool> checkSignin(User user) async {
// //   try {
// //     // user = FirebaseAuth.instance.currentUser;
// //     assert(user.email != null);
// //     assert(user.displayName != null);
// //     assert(!user.isAnonymous);
// //     assert(await user.getIdToken() != null);
// //     assert(user.uid == user.uid);
// //   } catch (e) {
// //     return false;
// //   }
// //   return true;
// // }

// Future<User> signInWithGoogle() async {
//   final GoogleSignInAccount gSA = await googleSignIn.signIn();
//   googleSignInAccount = gSA;
//   final GoogleSignInAuthentication googleSignInAuthentication = await gSA.authentication;

//   final AuthCredential credential = GoogleAuthProvider.credential(
//     accessToken: googleSignInAuthentication.accessToken,
//     idToken: googleSignInAuthentication.idToken,
//   );

//   final UserCredential authResult = await _auth.signInWithCredential(credential);
//   final User user = authResult.user;

//   assert(!user.isAnonymous);
//   assert(await user.getIdToken() != null);

//   User currentUser = _auth.currentUser;
//   assert(user.uid == currentUser.uid);

//   print('currentUser succeeded: ${currentUser.displayName}');
//   return currentUser;
// }

// Future<User> signUpWithEmail(String email, String password, String displayName) async {
//   assert(email != null);
//   assert(password != null);
//   assert(displayName != null);

//   UserCredential authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//     email: email,
//     password: password,
//   );

//   final User _user = authResult.user;
//   await _user.updateProfile(displayName: displayName);
//   await _user.reload();

//   await _user.sendEmailVerification();
//   return _user;
// }

// Future<void> resetPassword(String email) async {
//   //maybe show a toat or snackbar
//   print("If an account with that email exists, you will receive a password reset link shortly.");

//   await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
// }

// Future<User> signInWithEmail(String email, String password) async {
//   final UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
//     email: email,
//     password: password,
//   );

//   final User user = result.user;
//   return user;
// }

// Future<User> anonymousSignIn() async {
//   final UserCredential result = await FirebaseAuth.instance.signInAnonymously();
//   final User user = result.user;

//   // return await checkSignin(user);
//   return user;
// }

// Future<void> logOut() async {
//   try {
//     await googleSignIn.isSignedIn().then((value) {
//       if (value) googleSignIn.signOut();
//     });
//     await _auth.signOut();
//   } catch (e) {
//     print("\nerror logging out\n");
//   }
// }
