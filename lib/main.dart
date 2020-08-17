import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/enums/sizeConfig.dart';
import 'package:givnotes/pages/loginPage.dart';
import 'package:givnotes/ui/splashscreen.dart';
import 'package:givnotes/utils/home.dart';
import 'package:givnotes/utils/login.dart';
import 'package:givnotes/utils/notesDB.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() async {
  final appDir = await path.getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter(givnotesDBAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // showPerformanceOverlay: true,
          home: SplashScreen(
            // TODO change it to 3 sec
            seconds: 3,
            navigateAfterSeconds: CheckLogIn(),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

Future<String> get _localPath async {
  final dir = await path.getApplicationDocumentsDirectory();
  return dir.path;
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
    _localPath.then((value) => Directory("$value/notes").create());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (isSkipped == true) return HomePage();
        setFirstLaunch();

        if (snapshot.connectionState == ConnectionState.waiting)
          return Scaffold(backgroundColor: Colors.black);

        if (!snapshot.hasData || snapshot.data == null) return LoginPage();

        if (snapshot.hasData) temp = snapshot.data;
        return HomePage();
      },
    );
  }
}
