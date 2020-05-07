import 'package:flutter/material.dart';

class NoteInherited extends InheritedWidget {
  NoteInherited({Key key, this.child}) : super(key: key, child: child);

  final Widget child;

  final notes = [
    {
      'title': 'This is test title',
      'text': 'This is test note',
    },
    {
      'title': 'This is test title',
      'text': 'This is test note',
    },
    {
      'title': 'This is test title',
      'text': 'This is test note',
    },
  ];

  static NoteInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NoteInherited>();
  }

  @override
  bool updateShouldNotify(NoteInherited oldWidget) {
    return oldWidget.notes != notes;
  }
}

// inheritFromWidgetOfExactType(NoteInherited)
