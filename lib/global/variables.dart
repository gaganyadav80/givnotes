import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/database/HiveDB.dart';
import 'package:package_info/package_info.dart';

PrefsModel prefsBox;
PackageInfo packageInfo;
bool isPermanentDisabled = true;

enum NoteMode { Adding, Editing }

void showFlashToast(BuildContext context, String msg) {
  showFlash(
    context: context,
    duration: Duration(seconds: 5),
    builder: (_, controller) {
      return Flash(
        controller: controller,
        backgroundColor: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
        position: FlashPosition.bottom,
        style: FlashStyle.floating,
        enableDrag: false,
        margin: EdgeInsets.only(bottom: 10),
        onTap: () => controller.dismiss(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            child: Text(msg),
          ),
        ),
      );
    },
  );
}

Future<void> showCustomDialog(
  BuildContext context,
  String title, {
  String message,
  bool showCancle = false,
  String mainButtonText = 'Okay',
  Function onTap,
}) async {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: 350.0,
          // height: 180.0,
          padding: const EdgeInsets.only(top: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              message.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              showCancle
                  ? Divider(
                      height: 0.0,
                      color: Colors.black54,
                      thickness: 1.0,
                    )
                  : SizedBox.shrink(),
              showCancle
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          // height: 30.0,
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              Divider(
                height: 0.0,
                color: Colors.black54,
                thickness: 1.0,
              ),
              Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0)),
                ),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0)),
                  onTap: onTap == null ? () => Navigator.pop(context) : onTap,
                  child: Container(
                    // height: 30.0,
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Center(
                      child: Text(
                        mainButtonText,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
