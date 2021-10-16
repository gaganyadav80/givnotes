import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:givnotes/models/user_model.dart';
import 'package:givnotes/screens/screens.dart';
import 'package:givnotes/screens/src/todo_timeline/todo_timeline.dart';
import 'package:givnotes/services/services.dart';

import 'authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authRepo = authenticationRepository,
        super(
          authenticationRepository.currentUser.id == ''
              ? AuthInitial()
              : AuthSuccess(user: authenticationRepository.currentUser),
        ) {
    _userSubscription = _authRepo.user.listen((data) => _user = data);
  }

  final AuthenticationRepository _authRepo;
  StreamSubscription<UserModel> _userSubscription;
  UserModel _user;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    try {
      if (event is LoginButtonPressed) {
        yield (LoginInProgress());
        await _authRepo.logInWithEmailAndPassword(
            email: event.email, password: event.password);
        final User _currentUser = FirebaseAuth.instance.currentUser;

        await pluginInitializer(_currentUser.uid, userKey: event.password);

        if (_currentUser.emailVerified) {
          yield (AuthSuccess(user: _user, verify: event.verify));
        } else {
          yield AuthNeedsVerification(user: _user, verify: event.verify);
        }
      } else if (event is RegisterButtonClicked) {
        yield (RegisterInProgress());
        await _authRepo.signUp(
            email: event.email, password: event.password, name: event.name);
        final User _currentUser = FirebaseAuth.instance.currentUser;

        await pluginInitializer(_currentUser.uid, userKey: event.password);

        // final DatabaseReference db = FirebaseDatabase.instance.reference();
        // db.child('users').child('${_currentUser.uid}').set({
        //   'name': event.name,
        //   'email': event.email,
        //   'photoURL': _currentUser.photoURL,
        //   'full-paid': false,
        //   'ads-paid': false,
        // });

        final DocumentReference db = FirebaseFirestore.instance
            .collection("users")
            .doc(_currentUser?.uid);
        db.set({
          'name': event.name,
          'email': event.email,
          'photoURL': _currentUser.photoURL,
          'full-paid': false,
          'ads-paid': false,
        });

        yield (AuthNeedsVerification(user: _user));
        //
      } else if (event is LoginWithGoogle) {
        yield (LoginInProgress());

        await _authRepo.logInWithGoogle();
        yield (AuthSuccess(user: _user));
        //
      } else if (event is RegisterWithGoogle) {
        yield (RegisterInProgress());

        await _authRepo.logInWithGoogle();
        yield (AuthSuccess(user: _user));
        //
      } else if (event is ForgetPassword) {
        yield (LoginInProgress());
        await _authRepo.resetPassword(event.email);
        yield (ForgetPasswordSuccess());
        //
      } else if (event is LoginObscureEvent) {
        yield (LoginObscureState(obscure: event.obscureLogin));
        //
      } else if (event is RegisterObscureEvent) {
        yield (RegisterObscureState(
            obscure: event.obscure, obscureConfirm: event.obscureConfirm));
        //
      } else if (event is LogOutUser) {
        yield (LogoutInProgress());
        await _authRepo.logOut();
        BlocProvider.of<TodosBloc>(event.ctx).add(LoadTodos());
        yield (LogoutSuccess(user: _user));
        //
      }
    } on PlatformException catch (e) {
      yield (AuthFailure(message: "Error: ${e.message}"));
    } on FirebaseAuthException catch (e) {
      if (event is LoginButtonPressed) {
        if (event.verify) {
          final User _currentUser = FirebaseAuth.instance.currentUser;

          if (_currentUser.emailVerified) {
            yield (AuthSuccess(
                user: _user, verify: event.verify, verifyFailed: true));
          } else {
            yield AuthNeedsVerification(
                user: _user, verify: event.verify, verifyFailed: true);
          }
        } else {
          print("AUTH ERROR: ${e.message}");
          yield (AuthFailure(message: "Auth Error: ${e.code.toUpperCase()}"));
        }
      }
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
