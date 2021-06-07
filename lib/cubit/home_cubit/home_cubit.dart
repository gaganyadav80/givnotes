import 'package:bloc/bloc.dart';

class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0);

  void update(int value) => emit(value);

  // void updateIndex(int value) => emit(state.copyWith(index: value));
  // void updateTrash(bool value) => emit(state.copyWith(trash: value));
}

// class HomeState extends Equatable {
//   const HomeState({this.index = 0, this.trash = false});

//   final int index;
//   final bool trash;

//   @override
//   List<Object> get props => [index, trash];

//   HomeState copyWith({
//     int index,
//     bool trash,
//   }) {
//     return HomeState(
//       index: index ?? this.index,
//       trash: trash ?? this.trash,
//     );
//   }
// }
