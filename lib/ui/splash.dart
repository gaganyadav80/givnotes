import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 350.0),
              // CircularProgressIndicator(
              //   backgroundColor: Colors.black,
              //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              // ),
              SpinKitChasingDots(
                color: Colors.white,
              ),
              const SizedBox(height: 280),
              Text(
                "Checking your Google Login Status",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'SourceSansPro',
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
