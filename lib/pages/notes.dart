import 'package:flutter/material.dart';

import '../ui/drawerItems.dart';
import '../ui/homePageItems.dart';

enum NoteMode { Editing, Adding }

class NotesView extends StatelessWidget {
  final NoteMode _noteMode;
  NotesView(this._noteMode);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: DrawerItems(),
        appBar: MyAppBar(_noteMode == NoteMode.Adding ? 'NEW NOTE' : 'EDIT NOTE', true),
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Untitled'),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Empty Note',
                ),
              ),
              Container(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _NoteButton('Save', Colors.green, () {}),
                  _NoteButton('Discard', Colors.grey, () {}),
                  _noteMode == NoteMode.Editing
                      ? _NoteButton('Delete', Colors.red, () {})
                      : SizedBox(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onpressed;

  _NoteButton(this.text, this.color, [this.onpressed]);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      color: color,
    );
  }
}
