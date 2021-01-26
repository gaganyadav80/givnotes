import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:givnotes/packages/packages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

// class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
//   AuthenticationBloc() : super(AuthUnInitialized());

//   @override
//   Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
//     try {
//       if (event is AppStarted) {
//         yield AuthInProgress();
//         final _currentUser = FirebaseAuth.instance.currentUser;
//         if (_currentUser != null) {
//           if (_currentUser.emailVerified) {
//             yield AuthAuthenticated();
//           } else {
//             yield AuthNeedsVerification();
//           }
//         } else {
//           yield AuthUnAuthenticated();
//         }
//       } else if (state is JustLoggedOut) {
//         yield AuthInProgress();
//         await FirebaseAuth.instance.signOut();
//         await GoogleSignIn().signOut();
//         yield AuthUnAuthenticated(justLoggedOut: true);
//       }
//     } on PlatformException catch (e) {
//       yield (AuthFailure(message: "Error: ${e.message}"));
//     } on TimeoutException catch (e) {
//       yield (AuthFailure(message: "Timeout: ${e.message}"));
//     } on FirebaseAuthException catch (e) {
//       yield (AuthFailure(message: "Error: ${e.message}"));
//     } catch (e) {
//       yield (AuthFailure(message: e.toString()));
//     }
//   }
// }

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AuthenticationUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserModel> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      unawaited(_authenticationRepository.logOut());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) {
    return event.user != UserModel.empty ? AuthenticationState.authenticated(event.user) : const AuthenticationState.unauthenticated();
  }
}
