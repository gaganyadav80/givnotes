import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:givnotes/models/user_model.dart';

import 'authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authRepo = authenticationRepository,
        super(AuthInitial()) {
    _userSubscription = _authRepo.user.listen((_user) => user = _user);
  }

  final AuthenticationRepository _authRepo;
  StreamSubscription<UserModel> _userSubscription;
  UserModel user;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    try {
      if (event is LoginButtonPressed) {
        yield (LoginInProgress());
        await _authRepo.logInWithEmailAndPassword(email: event.email, password: event.password);
        final User _currentUser = FirebaseAuth.instance.currentUser;

        // if (_currentUser != null) user = UserModel(email: _currentUser.email, name: _currentUser.displayName, id: _currentUser.uid, photo: _currentUser.photoURL);

        if (_currentUser.emailVerified) {
          yield (AuthSuccess());
        } else {
          yield AuthNeedsVerification();
        }
      } else if (event is RegisterButtonClicked) {
        yield (RegisterInProgress());
        await _authRepo.signUp(email: event.email, password: event.password, name: event.name);
        final User _currentUser = FirebaseAuth.instance.currentUser;

        if (_currentUser.emailVerified) {
          yield (AuthSuccess());
        } else {
          yield (AuthNeedsVerification());
        }
      } else if (event is LoginWithGoogle) {
        yield (LoginInProgress());

        await _authRepo.logInWithGoogle();
        // final User _currentUser = FirebaseAuth.instance.currentUser;

        // if (_currentUser != null) user = UserModel(email: _currentUser.email, name: _currentUser.displayName, id: _currentUser.uid, photo: _currentUser.photoURL);

        yield (AuthSuccess());
      } else if (event is RegisterWithGoogle) {
        yield (RegisterInProgress());

        await _authRepo.logInWithGoogle();
        yield (AuthSuccess());
      } else if (event is ForgetPassword) {
        yield (LoginInProgress());
        await _authRepo.resetPassword(event.email);
        yield (ForgetPasswordSuccess());
      } else if (event is LoginObscureEvent) {
        yield (LoginObscureState(obscure: event.obscureLogin));
      } else if (event is RegisterObscureEvent) {
        yield (RegisterObscureState(obscure: event.obscure, obscureConfirm: event.obscureConfirm));
      }
    } on PlatformException catch (e) {
      yield (AuthFailure(message: "Error: ${e.message}"));
    } on FirebaseAuthException catch (e) {
      yield (AuthFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (AuthFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
