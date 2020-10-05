import 'dart:async';

import 'package:givnotes/database/database.dart';
import 'package:givnotes/models/notes_model.dart';

import 'bloc_provider.dart';

class NotesBloc implements BlocBase {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream you'll be using.
  final _notesController = StreamController<List<Note>>.broadcast();

  // Input stream. We add our notes to the stream using this variable.
  StreamSink<List<Note>> get _inNotes => _notesController.sink;

  // Output stream. This one will be used within our pages to display the notes.
  Stream<List<Note>> get notes => _notesController.stream;

  // Input stream for adding new notes. We'll call this from our pages.
  final _addNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inAddNote => _addNoteController.sink;

  /*
  Notes View Bloc
  */
  final _saveNoteController = StreamController<Note>.broadcast();
  StreamSink<Note> get inSaveNote => _saveNoteController.sink;

  final _deleteNoteController = StreamController<int>.broadcast();
  StreamSink<int> get inDeleteNote => _deleteNoteController.sink;

  // This bool StreamController will be used to ensure we don't do anything
  // else until a note is actually deleted from the database.
  final _noteDeletedController = StreamController<bool>.broadcast();
  StreamSink<bool> get _inDeleted => _noteDeletedController.sink;
  Stream<bool> get deleted => _noteDeletedController.stream;
  //

  NotesBloc() {
    // Retrieve all the notes on initialization
    getNotes();

    // Listens for changes to the addNoteController and calls _handleAddNote on change
    _addNoteController.stream.listen(_handleAddNote);

    _saveNoteController.stream.listen(_handleSaveNote);
    _deleteNoteController.stream.listen(_handleDeleteNote);
  }

  // All stream controllers you create should be closed within this function
  @override
  void dispose() {
    _notesController?.close();
    _addNoteController?.close();
  }

  void getNotes() async {
    // Retrieve all the notes from the database
    List<Note> notes = await NotesDBProvider.db.getNotes();

    // Add all of the notes to the stream so we can grab them later from our pages
    if (!_addNoteController.isClosed) _inNotes.add(notes);
  }

  void _handleAddNote(Note note) async {
    // Create the note in the database
    await NotesDBProvider.db.newNote(note);

    // Retrieve all the notes again after one is added.
    // This allows our pages to update properly and display the
    // newly added note.
    getNotes();
  }

  /*
  Notes View Bloc
  */
  void _handleSaveNote(Note note) async {
    await NotesDBProvider.db.updateNote(note);
  }

  void _handleDeleteNote(int id) async {
    await NotesDBProvider.db.deleteNote(id);

    // Set this to true in order to ensure a note is deleted
    // before doing anything else
    _inDeleted.add(true);
  }
}
