part of 'note_search_cubit.dart';

class NoteAndSearchState extends Equatable {
  const NoteAndSearchState({
    this.noteMode = NoteMode.Adding,
    this.isEditing = false,
    // this.noteModified,
    this.searchList = const [],
    this.tagSearchList = const [],
    this.selectedTagList = const [],
  });

  final NoteMode noteMode;
  final bool isEditing;
  // final DateTime noteModified;
  final List<NotesModel> searchList;
  final List<String> tagSearchList;
  final List<String> selectedTagList;

  @override
  List<Object> get props => [
        noteMode,
        isEditing,
        // noteModified,
        searchList,
        tagSearchList,
        selectedTagList,
      ];

  NoteAndSearchState copyWith({
    NoteMode noteMode,
    bool isEditing,
    // DateTime noteModified,
    List<NotesModel> searchList,
    List<String> tagSearchList,
    List<String> selectedTagList,
  }) {
    return NoteAndSearchState(
      noteMode: noteMode ?? this.noteMode,
      isEditing: isEditing ?? this.isEditing,
      // noteModified: noteModified ?? this.noteModified,
      searchList: searchList ?? this.searchList ?? [],
      tagSearchList: tagSearchList ?? this.tagSearchList ?? [],
      selectedTagList: selectedTagList ?? this.selectedTagList ?? [],
    );
  }
}

// class NoteInitial extends NoteAndSearchState {}
