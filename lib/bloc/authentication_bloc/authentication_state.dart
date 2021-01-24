part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = UserModel.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(UserModel user) : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.authNeedsVerification() : this._();

  const AuthenticationState.authenticationFailure() : this._();

  final AuthenticationStatus status;
  final UserModel user;

  @override
  List<Object> get props => [status, user];
}

// part of 'authentication_bloc.dart';

// abstract class AuthenticationState extends Equatable {
//   const AuthenticationState();

//   @override
//   List<Object> get props => [];
// }

// class AuthUnInitialized extends AuthenticationState {}

// class AuthAuthenticated extends AuthenticationState {}

// class AuthUnAuthenticated extends AuthenticationState {
//   final bool justLoggedOut;
//   AuthUnAuthenticated({this.justLoggedOut = false});

//   @override
//   List<Object> get props => [justLoggedOut];
// }

// class AuthInProgress extends AuthenticationState {}

// class AuthNeedsVerification extends AuthenticationState {}

// class AuthFailure extends AuthenticationState {
//   final String message;
//   AuthFailure({this.message});

//   @override
//   List<Object> get props => [message];
// }
