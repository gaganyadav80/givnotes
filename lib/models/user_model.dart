import 'dart:convert';

import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel({
    required this.email,
    required this.uid,
    required this.name,
    required this.photo,
    required this.verified,
    required this.createdAt,
    required this.fullPaid,
    required this.adsPaid,
    required this.isSocialLogin,
  });

  /// The current user's email address.
  final String email;

  /// The current user's id.
  final String uid;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  final bool verified;

  final DateTime? createdAt;

  final bool fullPaid;
  final bool adsPaid;
  final bool isSocialLogin;

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
      email: '',
      uid: '',
      name: null,
      photo: null,
      verified: false,
      createdAt: null,
      fullPaid: false,
      adsPaid: false,
      isSocialLogin: false);

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserModel.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [email, uid, name, photo, verified, createdAt, fullPaid, adsPaid, isSocialLogin];

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
      'name': name,
      'photo': photo,
      'verified': verified,
      'fullPaid': fullPaid,
      'adsPaid': adsPaid,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'isSocialLogin': isSocialLogin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      email: map!['email'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'],
      photo: map['photo'],
      verified: map['verified'] ?? false,
      fullPaid: map['fullPaid'] ?? false,
      adsPaid: map['adsPaid'] ?? false,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : null,
      isSocialLogin: map['isSocialLogin'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? email,
    // String? uid,
    String? name,
    String? photo,
    bool? verified,
    // DateTime? createdAt,
    bool? fullPaid,
    bool? adsPaid,
    // bool? isSocialLogin,
  }) {
    return UserModel(
      email: email ?? this.email,
      uid: uid,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      verified: verified ?? this.verified,
      createdAt: createdAt,
      fullPaid: fullPaid ?? this.fullPaid,
      adsPaid: adsPaid ?? this.adsPaid,
      isSocialLogin: isSocialLogin,
    );
  }
}
