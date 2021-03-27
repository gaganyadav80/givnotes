import 'package:flutter/material.dart';
import 'package:givnotes/global/utils.dart';

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
      // shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
      child: Container(
        height: screenHeight * 0.07394736842,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).splashColor,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: kBorderRadius,
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.018900889, // 17
            ),
          ),
          onPressed: onPressed,
          child: Center(
            child: isLoading
                ? Container(
                    // height: 30.0,
                    // width: 30.0,
                    color: Theme.of(context).splashColor,
                    height: screenHeight * 0.03547368421,
                    width: screenWidth * 0.07614213198,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    title,
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: screenHeight * 0.020,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}
