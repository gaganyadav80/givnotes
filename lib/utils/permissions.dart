import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class HandlePermission {
  Future<bool> requestPermission() async {
    await Permission.storage.request();
    if (await Permission.storage.isGranted) {
      return true;
    } else {
      if (await Permission.storage.isPermanentlyDenied) {
        isPermanentDisabled = true;
        return false;
      }
      return false;
    }
  }

  permanentDisabled(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open Settings?'),
          content: Text('To enable storage permission. \nCan\'t save your notes without it.'),
          actions: [
            FlatButton(
              child: Text(
                "Later",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 2.5 * hm,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text(
                "Sure",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 2.5 * hm,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}

// CupertinoAlertDialog(
//       title: Text('Open settings ?'),
//       content: Text(
//           'Please open the app settings \nto enable storage permission. \nCan\'t save your notes right now.\n'),
//       actions: <Widget>[
//         CupertinoDialogAction(
//           child: Text(
//             'Later',
//             style: GoogleFonts.sourceSansPro(
//               fontWeight: FontWeight.w300,
//               color: Colors.red,
//               fontSize: 16,
//             ),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           child: Text(
//             'Sure',
//             style: GoogleFonts.sourceSansPro(
//               fontWeight: FontWeight.w300,
//               fontSize: 16,
//             ),
//           ),
//           onPressed: () {
//             openAppSettings();
//             Navigator.pop(context);
//           },
//         )
//       ],
//     );

// void request() async {
// Map<Permission, PermissionStatus> status = await [
//   Permission.storage,
// ].request();

// if (await Permission.storage.isPermanentlyDenied && await Permission.storage.isDenied) {
//   isStorageDisabled = true;
//   print(status[Permission.storage]);
// } else {
//   isStorageDisabled = false;
//   print(status[Permission.storage]);
// }
// }
