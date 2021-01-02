part of 'auth_cubit.dart';

@immutable
class AuthState extends Equatable {
  const AuthState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.name = '',
    this.status = FormzStatus.pure,
    this.obscureTextLogin = true,
    this.obscureTextSignup = true,
    this.obscureTextSignupConfirm = true,
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final String name;
  final FormzStatus status;
  final bool obscureTextLogin;
  final bool obscureTextSignup;
  final bool obscureTextSignupConfirm;

  @override
  List<Object> get props => [
        email,
        password,
        confirmedPassword,
        name,
        status,
        obscureTextLogin,
        obscureTextSignup,
        obscureTextSignupConfirm,
      ];

  AuthState copyWith({
    Email email,
    Password password,
    ConfirmedPassword confirmedPassword,
    String name,
    FormzStatus status,
    bool obscureTextLogin,
    bool obscureTextSignup,
    bool obscureTextSignupConfirm,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      name: name ?? this.name,
      status: status ?? this.status,
      obscureTextLogin: obscureTextLogin ?? this.obscureTextLogin,
      obscureTextSignup: obscureTextSignup ?? this.obscureTextSignup,
      obscureTextSignupConfirm: obscureTextSignupConfirm ?? this.obscureTextSignupConfirm,
    );
  }
}
