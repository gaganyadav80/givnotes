import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/enums/sizeConfig.dart';
import 'package:givnotes/pages/loginPage.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/ui/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // showPerformanceOverlay: true,
          home: CheckLogIn(),
        );
      },
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
      if (skip == true || skip == false)
        isSkipped = skip;
      else
        isSkipped = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (isSkipped == true) return HomePage();
        setFirstLaunch();

        if (snapshot.connectionState == ConnectionState.waiting) return SplashPage();
        if (!snapshot.hasData || snapshot.data == null) return LoginPage();

        return HomePage();
      },
    );
  }
}
