import 'package:flutter/material.dart';

class GivnotesDialog extends StatelessWidget {
  const GivnotesDialog({
    Key key,
    @required this.title,
    this.message,
    this.showCancel = false,
    this.mainButtonText = "Okay",
    this.onTap,
  }) : super(key: key);

  final String title;
  final String message;
  final String mainButtonText;
  final bool showCancel;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            message.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 15.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            showCancel
                ? Divider(
                    height: 0.0,
                    color: Colors.black54,
                    thickness: 1.0,
                  )
                : SizedBox.shrink(),
            showCancel
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context, false),
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
                onTap: onTap == null ? () => Navigator.pop(context, true) : onTap,
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
  }
}
