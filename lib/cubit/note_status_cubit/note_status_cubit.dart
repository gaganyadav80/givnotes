import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givnotes/services/services.dart';

class NoteStatusCubit extends Cubit<NoteStatusState> {
  NoteStatusCubit() : super(const NoteStatusState());

  void updateNoteMode(NoteMode value) => emit(state.copyWith(noteMode: value));
  void updateIsEditing(bool value) => emit(state.copyWith(isEditing: value));
}

class NoteStatusState extends Equatable {
  const NoteStatusState(
      {this.noteMode = NoteMode.adding, this.isEditing = false});

  final NoteMode noteMode;
  final bool isEditing;

  @override
  List<Object> get props => [noteMode, isEditing];

  NoteStatusState copyWith({NoteMode? noteMode, bool? isEditing}) {
    return NoteStatusState(
      noteMode: noteMode ?? this.noteMode,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}
