part of 'hydrated_prefs_cubit.dart';

class HydratedPrefsState extends Equatable {
  const HydratedPrefsState({
    this.compactTags = false,
    this.sortBy = 0,
  });

  // 0: created, 1: modified, 2: a-z, 3: z-a
  final int sortBy;
  final bool compactTags;

  @override
  List<Object> get props => [sortBy, compactTags];

  HydratedPrefsState copyWith({
    int sortBy,
    bool compactTags,
  }) {
    return HydratedPrefsState(
      sortBy: sortBy ?? this.sortBy,
      compactTags: compactTags ?? this.compactTags,
    );
  }
}

// class HydratedPrefsInitial extends HydratedPrefsState {}
