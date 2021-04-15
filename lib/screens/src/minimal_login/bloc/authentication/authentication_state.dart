part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthenticationState {}

class LoginInProgress extends AuthenticationState {}

class RegisterInProgress extends AuthenticationState {}

class AuthSuccess extends AuthenticationState {}

class AuthNeedsVerification extends AuthenticationState {}

// class LoginNeedsProfileComplete extends LoginState {}

class ForgetPasswordSuccess extends AuthenticationState {}

class LoginObscureState extends AuthenticationState {
  final bool obscure;
  LoginObscureState({this.obscure});

  @override
  List<Object> get props => [obscure];
}

class RegisterObscureState extends AuthenticationState {
  final bool obscure;
  final bool obscureConfirm;
  RegisterObscureState({this.obscure, this.obscureConfirm});

  @override
  List<Object> get props => [obscure, this.obscureConfirm];
}

class AuthFailure extends AuthenticationState {
  final String message;
  AuthFailure({this.message});

  @override
  List<Object> get props => [message];
}

class LogoutInProgress extends AuthenticationState {}

class LogoutSuccess extends AuthenticationState {}
