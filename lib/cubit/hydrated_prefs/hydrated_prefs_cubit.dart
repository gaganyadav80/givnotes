import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'hydrated_prefs_state.dart';

class HydratedSortCubit extends HydratedCubit<String> {
  HydratedSortCubit() : super('created');

  @override
  String fromJson(Map<String, dynamic> json) => json['value'] as String;

  @override
  Map<String, dynamic> toJson(String value) => {'value': value};
}

class HydratedCompactCubit extends HydratedCubit<bool> {
  HydratedCompactCubit() : super(false);

  @override
  bool fromJson(Map<String, dynamic> json) => json['value'] as bool;

  @override
  Map<String, dynamic> toJson(bool value) => {'value': value};
}

//TODO throws error
class HydratedPrefsCubit extends Cubit<HydratedPrefsState> {
  HydratedPrefsCubit() : super(const HydratedPrefsState());

  void updateSortBy(String value) => emit(state.copyWith(sortBy: value));
  void updateCompactTags(bool value) => emit(state.copyWith(compactTags: value));

  // @override
  // HydratedPrefsState fromJson(Map<String, dynamic> json) => state.copyWith(
  //       compactTags: json['comapct'] as bool,
  //       sortBy: json['sort'] as String,
  //     );

  // @override
  // Map<String, dynamic> toJson(HydratedPrefsState value) => {
  //       'compact': value.compactTags ?? state.compactTags,
  //       'sort': value.sortBy ?? state.compactTags,
  //     };
}
