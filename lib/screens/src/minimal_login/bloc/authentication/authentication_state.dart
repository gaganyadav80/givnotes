// part of 'authentication_bloc.dart';

// abstract class AuthenticationState extends Equatable {
//   const AuthenticationState();

//   @override
//   List<Object?> get props => [];
// }

// class AuthInitial extends AuthenticationState {}

// class LoginInProgress extends AuthenticationState {}

// class RegisterInProgress extends AuthenticationState {}

// class AuthSuccess extends AuthenticationState {
//   final UserModel? user;
//   final bool verify;
//   final bool verifyFailed;
//   const AuthSuccess(
//       {required this.user, this.verify = false, this.verifyFailed = false});

//   @override
//   List<Object?> get props => [user, verify, verifyFailed];
// }

// class AuthNeedsVerification extends AuthenticationState {
//   final UserModel? user;
//   final bool verify;
//   final bool verifyFailed;
//   const AuthNeedsVerification(
//       {required this.user, this.verify = false, this.verifyFailed = false});

//   @override
//   List<Object?> get props => [user, verify, verifyFailed];
// }

// // class LoginNeedsProfileComplete extends LoginState {}

// class ForgetPasswordSuccess extends AuthenticationState {}

// class LoginObscureState extends AuthenticationState {
//   final bool? obscure;
//   const LoginObscureState({this.obscure});

//   @override
//   List<Object?> get props => [obscure];
// }

// class RegisterObscureState extends AuthenticationState {
//   final bool? obscure;
//   final bool? obscureConfirm;
//   const RegisterObscureState({this.obscure, this.obscureConfirm});

//   @override
//   List<Object?> get props => [obscure, obscureConfirm];
// }

// class AuthFailure extends AuthenticationState {
//   final String? message;
//   const AuthFailure({this.message});

//   @override
//   List<Object?> get props => [message];
// }

// class LogoutInProgress extends AuthenticationState {}

// class LogoutSuccess extends AuthenticationState {
//   final UserModel? user;
//   const LogoutSuccess({this.user});

//   @override
//   List<Object?> get props => [user];
// }
