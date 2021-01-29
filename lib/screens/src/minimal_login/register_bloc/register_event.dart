part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonClicked extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  RegisterButtonClicked({@required this.name, @required this.email, @required this.password})
      : assert(email != null),
        assert(password != null);

  @override
  List<Object> get props => [email, password];
}

class RegisterObscureEvent extends RegisterEvent {
  final bool obscure;
  final bool obscureConfirm;
  RegisterObscureEvent({this.obscure, this.obscureConfirm});

  @override
  List<Object> get props => [obscure, obscureConfirm];
}

class GoogleSignUpClicked extends RegisterEvent {}
