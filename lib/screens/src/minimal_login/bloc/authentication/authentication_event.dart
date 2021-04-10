part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends AuthenticationEvent {
  final String email;
  final String password;
  LoginButtonPressed({@required this.email, @required this.password})
      : assert(email != null),
        assert(password != null);

  @override
  List<Object> get props => [email, password];
}

class RegisterButtonClicked extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  RegisterButtonClicked({@required this.name, @required this.email, @required this.password})
      : assert(email != null),
        assert(password != null);

  @override
  List<Object> get props => [email, password];
}

class ForgetPassword extends AuthenticationEvent {
  final String email;
  ForgetPassword({this.email});

  @override
  List<Object> get props => [email];
}

class LoginObscureEvent extends AuthenticationEvent {
  final bool obscureLogin;
  LoginObscureEvent({this.obscureLogin});

  @override
  List<Object> get props => [obscureLogin];
}

class RegisterObscureEvent extends AuthenticationEvent {
  final bool obscure;
  final bool obscureConfirm;
  RegisterObscureEvent({this.obscure, this.obscureConfirm});

  @override
  List<Object> get props => [obscure, obscureConfirm];
}

class LoginWithGoogle extends AuthenticationEvent {}

class RegisterWithGoogle extends AuthenticationEvent {}
