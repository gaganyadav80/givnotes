import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/utils/noteInherited.dart';

import 'pages/home.dart';
import 'ui/splash.dart';
import 'utils/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoteInherited(
          child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        themeMode: ThemeMode.system,
        home: CheckLogIn(),
      ),
    );
  }
}

class CheckLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return SplashPage();
        if (!snapshot.hasData || snapshot.data == null) return LoginPage();

        return HomePage();
      },
    );
  }
}
