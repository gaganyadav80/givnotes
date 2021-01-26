import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:givnotes/screens/src/minimal_login/functions/signIn.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    try {
      if (event is LoginButtonPressed) {
        yield (LoginInProgress());
        await signInWithEmailAndPass(email: event.email, password: event.password);
        final _currentUser = FirebaseAuth.instance.currentUser;
        if (_currentUser.emailVerified) {
          yield (LoginSuccess());
        } else {
          yield LoginNeedsVerification();
        }
      } else if (event is LoginWithGoogle) {
        yield (LoginInProgress());

        final _googleSignIn = GoogleSignIn();
        final _googleSigninAccount = await _googleSignIn.signIn();
        final _googleAuth = await _googleSigninAccount.authentication;
        // final _authCredentials = GoogleAuthProvider.getCredential(
        //   idToken: _googleAuth.idToken,
        //   accessToken: _googleAuth.accessToken,
        // );
        final _authCredentials = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(_authCredentials);
        final _currentUser = FirebaseAuth.instance.currentUser;
        yield (LoginSuccess());
      } else if (event is ForgetPassword) {
        yield (LoginInProgress());
        await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
        yield (ForgetPasswordSuccess());
      }
    } on PlatformException catch (e) {
      yield (LoginFailure(message: "Error: ${e.message}"));
    } on FirebaseAuthException catch (e) {
      yield (LoginFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (LoginFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (LoginFailure(message: e.toString()));
    }
  }
}
