part of 'hydrated_prefs_cubit.dart';

class HydratedPrefsState extends Equatable {
  const HydratedPrefsState({
    this.compactTags = false,
    this.sortBy = 'created',
  });

  // created, modified, a-z, z-a
  final String sortBy;
  final bool compactTags;

  @override
  List<Object> get props => [sortBy, compactTags];

  HydratedPrefsState copyWith({
    String sortBy,
    bool compactTags,
  }) {
    return HydratedPrefsState(
      sortBy: sortBy ?? this.sortBy,
      compactTags: compactTags ?? this.compactTags,
    );
  }
}

// class HydratedPrefsInitial extends HydratedPrefsState {}
