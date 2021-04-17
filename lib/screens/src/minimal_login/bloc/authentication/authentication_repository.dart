import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:givnotes/models/models.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class SignUpFailure implements Exception {}

class LogInWithEmailAndPasswordFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? UserModel.empty : firebaseUser.toUser;
    });
  }

  Future<void> signUp({
    @required String email,
    @required String password,
    @required String name,
  }) async {
    assert(email != null && password != null && name != null);
    try {
      final firebase_auth.UserCredential _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // final firebase_auth.User _user = _authResult.user;
      await _authResult.user.updateProfile(displayName: name);
      await _authResult.user.reload();
      await _authResult.user.sendEmailVerification();
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final firebase_auth.OAuthCredential _authCredential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken,
        idToken: _googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(_authCredential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> resetPassword(String email) async {
    await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() async {
    try {
      // await Future.wait([
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      // ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  UserModel get toUser {
    return UserModel(id: uid, email: email, name: displayName, photo: photoURL, verified: emailVerified);
  }
}
