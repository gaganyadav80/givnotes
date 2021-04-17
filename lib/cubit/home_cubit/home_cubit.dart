import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void updateIndex(int value) => emit(state.copyWith(index: value));
  void updateTrash(bool value) => emit(state.copyWith(trash: value));
}

class HomeState extends Equatable {
  const HomeState({this.index = 0, this.trash = false});

  final int index;
  final bool trash;
  // final bool global;

  @override
  List<Object> get props => [index, trash];

  HomeState copyWith({
    int index,
    bool trash,
    bool global,
  }) {
    return HomeState(
      index: index ?? this.index,
      trash: trash ?? this.trash,
    );
  }
}
