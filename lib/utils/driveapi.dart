import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:givnotes/utils/login.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;
  GoogleHttpClient(this._headers) : super();
  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));
  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}

// Upload File to Google Drive
uploadFileToGoogleDrive(BuildContext context) async {
  if (googleSignIn.currentUser == null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Please login first!'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  } else {
    googleSignInAccount = googleSignIn.currentUser;
    // print(googleSignInAccount);

    // GoogleHttpClient client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    // ga.DriveApi drive = ga.DriveApi(client);

    // ga.File notesToUpload = ga.File();
    // ga.File dbToUpload = ga.File();
    // final appDirPath = (await getApplicationDocumentsDirectory()).path;
    final dbpath = await getDatabasesPath();

    // final notes = Directory("$appDirPath/notes/").listSync();

// !! no such file or directory error for db file
// TODO upload db to firebase storage + change it to hive for encryption
    File dbfile = File("$dbpath/givenotes.db");
    // File file;

    debugPrint("DB PATH = ${dbfile.path} ++++++++++++++++++++++++++++++++++++++++++++++++");

// TODO delete all files before uploading again
// TODO need to logout and login on app startup to upload
    // if (dbfile != null || notes.isNotEmpty) {
    //   notes.forEach((element) async {
    //     file = File(element.path);
    //     debugPrint("NOTE = ${file.path} +++++++++++++++++++++++++++++++++++++++");
    //     notesToUpload.parents = ["appDataFolder"];
    //     notesToUpload.name = path.basename(file.absolute.path);

    //     var response = await drive.files.create(
    //       notesToUpload,
    //       uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
    //     );
    //     print(response);
    //   });

    //   dbToUpload.parents = ["appDataFolder"];
    //   dbToUpload.name = path.basename(dbfile.absolute.path);

    //   var dbresponse = await drive.files.create(
    //     dbToUpload,
    //     uploadMedia: ga.Media(dbfile.openRead(), dbfile.lengthSync()),
    //   );

    //   print(dbresponse);
    // } else {
    //   print("DONOT UPLOAD");
    // }
  }
}

// List Uploaded Files to Google Drive
// Future<void> _listGoogleDriveFiles() async {
//   var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
//   var drive = ga.DriveApi(client);
//   drive.files.list(spaces: 'appDataFolder').then((value) {
//     // setState(() {
//     ga.FileList list = value;
//     // });
//     for (var i = 0; i < list.files.length; i++) {
//       print("Id: ${list.files[i].id} File Name:${list.files[i].name}");
//     }
//   });
// }

// Download Google Drive File
Future<void> downloadGoogleDriveFile(String fName, String gdID) async {
  var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
  var drive = ga.DriveApi(client);
  ga.Media file = await drive.files.get(gdID, downloadOptions: ga.DownloadOptions.FullMedia);
  // print(file.stream);

  final directory = (await getApplicationDocumentsDirectory()).path;
  final saveNotes = File('$directory/notes/');

  final db = await getDatabasesPath();

  List<int> dataStore = [];
  file.stream.listen((data) {
    print("DataReceived: ${data.length}");
    dataStore.insertAll(dataStore.length, data);
    //
  }, onDone: () {
    print("Task Done");
    saveNotes.writeAsBytes(dataStore);
    print("File saved at ${saveNotes.path}");
    //
    File("$directory/notes/givnotes.db").copy("$db/");
    File("$directory/notes/givnotes.db").delete();
    //
  }, onError: (error) {
    print("Some Error");
  });
}
