import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'ui/splash.dart';
import 'utils/login.dart';

bool isSkipped = false;
Color lightBlue = Color(0xff91dcf5), darkGrey = Color(0xff7D9098);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      home: CheckLogIn(),
    );
  }
}

class CheckLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (isSkipped == true) return HomePage();
        if (snapshot.connectionState == ConnectionState.waiting) return SplashPage();
        if (!snapshot.hasData || snapshot.data == null) return SplashPage();

        return HomePage();
      },
    );
  }
}
