part of 'hydrated_prefs_cubit.dart';

class HydratedPrefsState extends Equatable {
  const HydratedPrefsState({
    this.compactTags = false,
    this.sortby = 0,
  });

  // 0: created, 1: modified, 2: a-z, 3: z-a
  final int? sortby;
  final bool? compactTags;

  @override
  List<Object?> get props => [sortby, compactTags];

  HydratedPrefsState copyWith({
    int? sortby,
    bool? compactTags,
  }) {
    return HydratedPrefsState(
      sortby: sortby ?? this.sortby,
      compactTags: compactTags ?? this.compactTags,
    );
  }
}
