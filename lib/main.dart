import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/pages/loginPage.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/ui/splash.dart';

// TODO: hide the status bar on login or everywhere
// TODO: suggest to connect to internet on first launch
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      themeMode: ThemeMode.system,
      home: CheckLogIn(),
    );
  }
}

class CheckLogIn extends StatefulWidget {
  @override
  _CheckLogInState createState() => _CheckLogInState();
}

class _CheckLogInState extends State<CheckLogIn> {
  @override
  void initState() {
    Var.selectedIndex = 0;
    Var.isTrash = false;
    getSkip().then((bool skip) {
      setState(() {
        // isSkipped = skip ?? false;
        if (skip == true || skip == false)
          isSkipped = skip;
        else
          isSkipped = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        // if (isSkipped == true) return HomePage();

        if (snapshot.connectionState == ConnectionState.waiting) return SplashPage();
        if (!snapshot.hasData || snapshot.data == null) return SplashPage();

        return HomePage();
      },
    );
  }
}
