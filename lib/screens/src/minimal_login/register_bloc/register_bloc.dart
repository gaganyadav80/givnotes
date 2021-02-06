import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:givnotes/screens/src/minimal_login/functions/signUp.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterButtonClicked) {
      try {
        yield (RegisterInProgress());
        await signUpWithEmailAndPass(name: event.name, email: event.email, password: event.password);
        yield (RegisterSuccess());
      } catch (e) {
        yield (RegisterFailed(message: e.toString()));
      }
    } else if (event is GoogleSignUpClicked) {
      try {
        yield (RegisterInProgress());

        final GoogleSignIn _googleSignIn = GoogleSignIn.standard();
        final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
        final AuthCredential _authCredentials = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(_authCredentials);

        yield (RegisterSuccess());
      } on PlatformException catch (e) {
        yield (RegisterFailed(message: "Error: ${e.message}"));
      } on FirebaseAuthException catch (e) {
        yield (RegisterFailed(message: "Error: ${e.message}"));
      } on TimeoutException catch (e) {
        yield (RegisterFailed(message: "Timeout: ${e.message}"));
      } catch (e) {
        yield (RegisterFailed(message: e.toString()));
      }
    } else if (event is RegisterObscureEvent) {
      yield (RegisterObscureState(obscure: event.obscure, obscureConfirm: event.obscureConfirm));
    }
  }
}