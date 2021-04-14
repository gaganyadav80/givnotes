import 'package:flutter/material.dart';
import 'package:givnotes/global/size_utils.dart';

import 'constants.dart';

class BlueButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final bool isLoading;
  BlueButton({@required this.title, @required this.onPressed, this.isLoading = false})
      : assert(onPressed != null),
        assert(title != null);
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: kBorderRadius,
      color: Colors.transparent,
      elevation: 5.0,
      shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          onPrimary: Theme.of(context).splashColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: kBorderRadius,
          ),
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.018900889, // 17
          ),
          primary: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: isLoading
              ? Container(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  title,
                  style: Theme.of(context).textTheme.button.copyWith(
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
        ),
      ),
    );
  }
}
