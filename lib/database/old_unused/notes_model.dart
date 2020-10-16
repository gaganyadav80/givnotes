// class Note {
//   int id;
//   String title;
//   String text;
//   String znote;
//   int trash;
//   String created;
//   String modified;

//   Note({
//     this.id,
//     this.title,
//     this.text,
//     this.znote,
//     this.trash,
//     this.created,
//     this.modified,
//   });

//   // Create a Note from JSON data
//   factory Note.fromJson(Map<String, dynamic> json) => Note(
//         id: json["id"],
//         title: json["title"],
//         text: json["text"],
//         znote: json["znote"],
//         trash: json["trash"],
//         created: json["created"],
//         modified: json["modified"],
//       );

//   // Convert our Note to JSON to make it easier when we store it in the database
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "text": text,
//         "znote": znote,
//         "trash": trash,
//         "created": created,
//         "modified": modified,
//       };
// }
