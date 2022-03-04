import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel({
    required this.email,
    required this.id,
    required this.name,
    required this.photo,
    required this.verified,
  })  : assert(email != null),
        assert(id != null);

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  final bool verified;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(email: '', id: '', name: null, photo: null, verified: false);

  @override
  List<Object?> get props => [email, id, name, photo, verified];
}
