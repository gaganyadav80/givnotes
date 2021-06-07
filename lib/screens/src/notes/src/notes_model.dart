import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class NotesModel extends Equatable {
  final String id;
  final String title;
  final String text;
  final String znote;
  final bool trash;
  final String created;
  final String modified;
  final List<String> tags;

  NotesModel({
    String id,
    @required this.title,
    @required this.text,
    @required this.znote,
    this.trash = false,
    @required this.created,
    @required this.modified,
    List<String> tags,
  })  : this.tags = tags ?? <String>[],
        this.id = id ?? Uuid().v1();

  NotesModel copyWith({
    String id,
    String title,
    String text,
    String znote,
    bool trash,
    String created,
    String modified,
    List<String> tags,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      znote: znote ?? this.znote,
      trash: trash ?? this.trash,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object> get props => [id, title, text, znote, trash, created, modified, tags];

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      text.hashCode ^
      znote.hashCode ^
      trash.hashCode ^
      created.hashCode ^
      modified.hashCode ^
      tags.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          text == other.text &&
          znote == other.znote &&
          trash == other.trash &&
          created == other.created &&
          modified == other.modified &&
          tags == other.tags;

  @override
  String toString() {
    return 'Note { id: $id, title: $title, text: $text, znote: $znote, trash: $trash, created: $created, modified: $modified, tags: $tags }';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "text": text,
      "znote": znote,
      "trash": trash,
      "created": created,
      "modified": modified,
      "tags": tags,
    };
  }

  static NotesModel fromJson(Map<String, dynamic> json) {
    return NotesModel(
      id: json["id"] as String,
      title: json["title"] as String,
      text: json["text"] as String,
      znote: json["znote"] as String,
      trash: json["trash"] as bool,
      created: json["created"] as String,
      modified: json["modified"] as String,
      tags: (json["tags"] as List)?.map((item) => item as String)?.toList(),
    );
  }
}
