import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:givnotes/services/services.dart';

part 'note_search_state.dart';

//TODO use replay cubit for zefyrController (undo and redo) --> LATER
class NoteAndSearchCubit extends Cubit<NoteAndSearchState> {
  NoteAndSearchCubit() : super(NoteAndSearchState());

  void updateNoteMode(NoteMode value) => emit(state.copyWith(noteMode: value));
  void updateIsEditing(bool value) => emit(state.copyWith(isEditing: value));
  // void updateNoteModified(DateTime value) => emit(state.copyWith(noteModified: value));

  void clearSearchList() => emit(state.copyWith(searchList: List<NotesModel>()));
  void clearTagSearchList() => emit(state.copyWith(tagSearchList: List<String>()));

  void updateSearchList(List<NotesModel> value) => emit(state.copyWith(searchList: value));
  void updateTagSearchList(List<String> list) => emit(state.copyWith(tagSearchList: list));

  void addSelectedTagList(String value) {
    List<String> temp = state.selectedTagList.toList();
    temp.add(value);

    emit(state.copyWith(selectedTagList: temp));
  }

  void removeSelectedTagList(String value) {
    List<String> temp = state.selectedTagList.toList();
    temp.remove(value);

    emit(state.copyWith(selectedTagList: temp));
  }

  void clearSelectedTagSearchList() => emit(state.copyWith(selectedTagList: List<String>()));
}
