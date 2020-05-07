import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  // backgroundColor: Colors.black,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Loading ...",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SourceSansPro - Light',
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
