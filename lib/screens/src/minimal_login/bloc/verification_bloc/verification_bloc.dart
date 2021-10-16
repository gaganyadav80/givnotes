import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationInitial());

  @override
  Stream<VerificationState> mapEventToState(
    VerificationEvent event,
  ) async* {
    try {
      if (event is VerificationInitiated) {
        yield (VerificationInProgress());

        await FirebaseAuth.instance.currentUser.reload();
        final _user = FirebaseAuth.instance.currentUser;

        bool _isEmailVerified = _user.emailVerified;

        if (_isEmailVerified) {
          yield (VerificationSuccess());
        } else if (event.isFirstTime) {
          yield (VerificationInitial());
        } else {
          yield (const VerificationFailed(
              message: "verification: user-not-verified"));
        }
      } else if (event is ResendVerificationMail) {
        yield (ResendVerificationInProgress());
        final _user = FirebaseAuth.instance.currentUser;
        await _user.sendEmailVerification();
        yield (ResendVerification());
      }
    } on FirebaseAuthException catch (e) {
      yield (VerificationFailed(message: "verification: ${e.code}"));
    } on PlatformException catch (e) {
      yield (VerificationFailed(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (VerificationFailed(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (VerificationFailed(message: e.toString()));
    }
  }
}
