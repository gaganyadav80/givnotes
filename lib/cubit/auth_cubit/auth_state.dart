// // part of 'auth_cubit.dart';

// // @immutable
// // class AuthState extends Equatable {
// //   const AuthState({
// //     this.email = const Email.pure(),
// //     this.password = const Password.pure(),
// //     this.confirmedPassword = const ConfirmedPassword.pure(),
// //     this.name = '',
// //     this.status = FormzStatus.pure,
// //     this.obscureTextLogin = true,
// //     this.obscureTextSignup = true,
// //     this.obscureTextSignupConfirm = true,
// //     this.error = 'no error',
// //   });

// //   final Email email;
// //   final Password password;
// //   final ConfirmedPassword confirmedPassword;
// //   final String name;
// //   final FormzStatus status;
// //   final bool obscureTextLogin;
// //   final bool obscureTextSignup;
// //   final bool obscureTextSignupConfirm;
// //   final String error;

// //   @override
// //   List<Object> get props => [
// //         email,
// //         password,
// //         confirmedPassword,
// //         name,
// //         status,
// //         obscureTextLogin,
// //         obscureTextSignup,
// //         obscureTextSignupConfirm,
// //         error,
// //       ];

// //   AuthState copyWith({
// //     Email email,
// //     Password password,
// //     ConfirmedPassword confirmedPassword,
// //     String name,
// //     FormzStatus status,
// //     bool obscureTextLogin,
// //     bool obscureTextSignup,
// //     bool obscureTextSignupConfirm,
// //     String error,
// //   }) {
// //     return AuthState(
// //       email: email ?? this.email,
// //       password: password ?? this.password,
// //       confirmedPassword: confirmedPassword ?? this.confirmedPassword,
// //       name: name ?? this.name,
// //       status: status ?? this.status,
// //       obscureTextLogin: obscureTextLogin ?? this.obscureTextLogin,
// //       obscureTextSignup: obscureTextSignup ?? this.obscureTextSignup,
// //       obscureTextSignupConfirm: obscureTextSignupConfirm ?? this.obscureTextSignupConfirm,
// //       error: error ?? this.error,
// //     );
// //   }
// // }
// part of 'auth_cubit.dart';

// @immutable
// class AuthState extends Equatable {
//   const AuthState({
//     this.email,
//     this.password,
//     this.confirmedPassword,
//     this.name = '',
//     // this.status = FormzStatus.pure,
//     this.status,
//     this.obscureTextLogin = true,
//     this.obscureTextSignup = true,
//     this.obscureTextSignupConfirm = true,
//     this.error = 'no error',
//   });

//   final String email;
//   final String password;
//   final String confirmedPassword;
//   final String name;
//   // final FormzStatus status;
//   final String status;
//   final bool obscureTextLogin;
//   final bool obscureTextSignup;
//   final bool obscureTextSignupConfirm;
//   final String error;

//   @override
//   List<Object> get props => [
//         email,
//         password,
//         confirmedPassword,
//         name,
//         // status,
//         obscureTextLogin,
//         obscureTextSignup,
//         obscureTextSignupConfirm,
//         error,
//       ];

//   AuthState copyWith({
//     String email,
//     String password,
//     String confirmedPassword,
//     String name,
//     // FormzStatus status,
//     String status,
//     bool obscureTextLogin,
//     bool obscureTextSignup,
//     bool obscureTextSignupConfirm,
//     String error,
//   }) {
//     return AuthState(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       confirmedPassword: confirmedPassword ?? this.confirmedPassword,
//       name: name ?? this.name,
//       status: status ?? this.status,
//       obscureTextLogin: obscureTextLogin ?? this.obscureTextLogin,
//       obscureTextSignup: obscureTextSignup ?? this.obscureTextSignup,
//       obscureTextSignupConfirm: obscureTextSignupConfirm ?? this.obscureTextSignupConfirm,
//       error: error ?? this.error,
//     );
//   }
// }

// class SubmissionInProgress extends AuthState {}

// class SubmissionSuccess extends AuthState {}

// class SubmissionFailure extends AuthState {
//   final String error;

//   SubmissionFailure({this.error});
//   @override
//   List<Object> get props => [error];
// }
