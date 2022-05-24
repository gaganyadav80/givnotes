// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:givnotes/models/models.dart';
// import 'package:givnotes/services/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:meta/meta.dart';

// class SignUpFailure implements Exception {}

// class LogInWithEmailAndPasswordFailure implements Exception {}

// class LogInWithGoogleFailure implements Exception {}

// class LogOutFailure implements Exception {}

// /// {@template authentication_repository}
// /// Repository which manages user authentication.
// /// {@endtemplate}
// class AuthenticationRepository {
//   AuthenticationRepository({
//     CacheClient? cache,
//     firebase_auth.FirebaseAuth? firebaseAuth,
//     GoogleSignIn? googleSignIn,
//   })  : _cache = cache ?? CacheClient(),
//         _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
//         _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

//   final CacheClient _cache;
//   final firebase_auth.FirebaseAuth _firebaseAuth;
//   final GoogleSignIn _googleSignIn;

//   @visibleForTesting
//   static const userCacheKey = '__user_cache_key__';

//   Stream<UserModel> get user {
//     return _firebaseAuth.userChanges().map((firebaseUser) {
//       final user = firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
//       _cache.write(key: userCacheKey, value: user);
//       return user;
//     });
//   }

//   UserModel get currentUser {
//     return _cache.read<UserModel>(key: userCacheKey) ?? UserModel.empty;
//   }

//   Future<void> signUp({
//     required String email,
//     required String password,
//     required String name,
//   }) async {
//     try {
//       final firebase_auth.UserCredential _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await _authResult.user!.updateDisplayName(name);
//       // await _authResult.user.reload();
//       await _authResult.user!.sendEmailVerification();
//     } on Exception {
//       throw SignUpFailure();
//     }
//   }

//   Future<void> logInWithGoogle() async {
//     try {
//       final GoogleSignInAccount _googleUser = await (_googleSignIn.signIn() as FutureOr<GoogleSignInAccount>);
//       final GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
//       final firebase_auth.OAuthCredential _authCredential = firebase_auth.GoogleAuthProvider.credential(
//         accessToken: _googleAuth.accessToken,
//         idToken: _googleAuth.idToken,
//       );
//       await _firebaseAuth.signInWithCredential(_authCredential);
//     } on Exception {
//       throw LogInWithGoogleFailure();
//     }
//   }

//   Future<void> logInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } on Exception {
//       throw LogInWithEmailAndPasswordFailure();
//     }
//   }

//   Future<void> resetPassword(String email) async {
//     await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//   }

//   Future<void> logOut() async {
//     try {
//       await Future.wait([
//         _firebaseAuth.signOut(),
//         _googleSignIn.signOut(),
//       ]);
//     } on Exception {
//       throw LogOutFailure();
//     }
//   }
// }

// extension on firebase_auth.User {
//   UserModel get toUser {
//     return UserModel(uid: uid, email: email!, name: displayName, photo: photoURL, verified: emailVerified);
//   }
// }
