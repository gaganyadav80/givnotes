import 'package:bloc/bloc.dart';

class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0);

  void update(int value) => emit(value);

  // void updateIndex(int value) => emit(state.copyWith(index: value));
  // void updateTrash(bool value) => emit(state.copyWith(trash: value));
}
