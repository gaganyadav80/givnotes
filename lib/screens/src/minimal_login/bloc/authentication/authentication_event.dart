part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends AuthenticationEvent {
  final String email;
  final String password;
  final bool verify;
  const LoginButtonPressed(
      {required this.email, required this.password, this.verify = false})
      : assert(email != null),
        assert(password != null);

  @override
  List<Object> get props => [email, password, verify];
}

class RegisterButtonClicked extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  const RegisterButtonClicked(
      {required this.name, required this.email, required this.password})
      : assert(email != null),
        assert(password != null);

  @override
  List<Object> get props => [email, password];
}

class ForgetPassword extends AuthenticationEvent {
  final String? email;
  const ForgetPassword({this.email});

  @override
  List<Object?> get props => [email];
}

class LoginObscureEvent extends AuthenticationEvent {
  final bool? obscureLogin;
  const LoginObscureEvent({this.obscureLogin});

  @override
  List<Object?> get props => [obscureLogin];
}

class RegisterObscureEvent extends AuthenticationEvent {
  final bool? obscure;
  final bool? obscureConfirm;
  const RegisterObscureEvent({this.obscure, this.obscureConfirm});

  @override
  List<Object?> get props => [obscure, obscureConfirm];
}

class LoginWithGoogle extends AuthenticationEvent {}

class RegisterWithGoogle extends AuthenticationEvent {}

class LogOutUser extends AuthenticationEvent {
  final BuildContext? ctx;
  const LogOutUser([this.ctx]);

  @override
  List<Object?> get props => [ctx];
}
