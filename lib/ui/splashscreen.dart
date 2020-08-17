import 'dart:core';
import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';

class SplashScreen extends StatefulWidget {
  final int seconds;
  final Color backgroundColor;
  final dynamic navigateAfterSeconds;
  SplashScreen({
    @required this.seconds,
    this.navigateAfterSeconds,
    this.backgroundColor = Colors.white,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: widget.seconds), () {
      if (widget.navigateAfterSeconds is String) {
        // It's fairly safe to assume this is using the in-built material
        // named route component
        Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
        //
      } else if (widget.navigateAfterSeconds is Widget) {
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (BuildContext context) => widget.navigateAfterSeconds));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.navigateAfterSeconds,
          ),
        );
      } else {
        throw ArgumentError('widget.navigateAfterSeconds must either be a String or Widget');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 12 * hm, left: 5 * wm),
            child: Row(
              children: <Widget>[
                Text(
                  'Giv',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 5 * wm,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Notes.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 5 * wm,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 15 * hm),
          Center(
            child: Container(
              height: 40 * wm,
              child: FlareActor(
                'assets/animations/loading.flr',
                animation: 'Alarm',
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              "Powered by GivNotes Inc.",
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 4.5 * wm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
