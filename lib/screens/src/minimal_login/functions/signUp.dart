import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> signUpWithEmailAndPass({@required String name, @required String email, @required String password}) async {
  assert(email != null && password != null);
  final UserCredential _authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  await _authResult.user.updateProfile(displayName: name);
  await _authResult.user.reload();
  await _authResult.user.sendEmailVerification();
}
