import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void updateIndex(int value) => emit(state.copyWith(index: value));
  void updateTrash(bool value) => emit(state.copyWith(trash: value));
  void updateGlobal(bool value) => emit(state.copyWith(global: value));
}

class HomeState extends Equatable {
  const HomeState({this.index = 0, this.trash = false, this.global = false});

  final int index;
  final bool trash;
  final bool global;

  @override
  List<Object> get props => [index, trash, global];

  HomeState copyWith({
    int index,
    bool trash,
    bool global,
  }) {
    return HomeState(
      index: index ?? this.index,
      trash: trash ?? this.trash,
      global: global ?? this.global,
    );
  }
}
