part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  LoginButtonPressed({@required this.email, @required this.password})
      : assert(email != null),
        assert(password != null);

  @override
  List<Object> get props => [email, password];
}

class ForgetPassword extends LoginEvent {
  final String email;
  ForgetPassword({this.email});

  @override
  List<Object> get props => [email];
}

class LoginObscureEvent extends LoginEvent {
  final bool obscureLogin;
  LoginObscureEvent({this.obscureLogin});

  @override
  List<Object> get props => [obscureLogin];
}

class LoginWithGoogle extends LoginEvent {}
