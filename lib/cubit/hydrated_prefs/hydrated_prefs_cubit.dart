import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'hydrated_prefs_state.dart';

class HydratedPrefsCubit extends HydratedCubit<HydratedPrefsState> {
  HydratedPrefsCubit() : super(const HydratedPrefsState());

  void updateSortBy(String value) => emit(state.copyWith(sortBy: value));
  void updateCompactTags(bool value) => emit(state.copyWith(compactTags: value));

  @override
  HydratedPrefsState fromJson(Map<String, dynamic> json) {
    try {
      return HydratedPrefsState(
        compactTags: json['compact'] as bool,
        sortBy: json['sort'] as String,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(HydratedPrefsState value) => <String, dynamic>{
        'compact': value.compactTags ?? state.compactTags,
        'sort': value.sortBy ?? state.compactTags,
      };
}
