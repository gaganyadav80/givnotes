import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:givnotes/pages/home.dart';
import 'package:givnotes/ui/splash.dart';
import 'package:givnotes/utils/login.dart';

// TODO: hide the status bar on login or everywhere
Color lightBlue = Color(0xff91dcf5), darkGrey = Color(0xff7D9098);
bool isSkipped;

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

void setSkip({bool skip}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('bool', skip);
}

Future<bool> getSkip() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('bool');
}

class CheckLogIn extends StatefulWidget {
  @override
  _CheckLogInState createState() => _CheckLogInState();
}

class _CheckLogInState extends State<CheckLogIn> {
  @override
  void initState() {
    getSkip().then((bool skip) {
      print('pre update skip: $skip and isSkipped: $isSkipped');
      setState(() {
        // isSkipped = skip ?? false;
        if (skip == true || skip == false)
          isSkipped = skip;
        else
          isSkipped = false;
      });
      print('post update skip: $skip and isSkipped: $isSkipped');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (isSkipped == true) return NotesView(isTrash: false);
        if (snapshot.connectionState == ConnectionState.waiting) return SplashPage();
        if (!snapshot.hasData || snapshot.data == null) return LoginPage();

        return NotesView(isTrash: false);
      },
    );
  }
}

// _write(String text) async {
//   final Directory directory = await getApplicationDocumentsDirectory();
//   final File file = File('${directory.path}/isSkipped.txt');
//   await file.writeAsString(text);
// }

// Future<String> _read() async {
//   String text;
//   try {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final File file = File('${directory.path}/my_file.txt');
//     text = await file.readAsString();
//   } catch (e) {
//     print("Couldn't read file");
//   }
//   return text;
// }
