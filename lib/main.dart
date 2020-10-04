import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:givnotes/enums/homeVariables.dart';
import 'package:givnotes/enums/prefs.dart';
import 'package:givnotes/enums/sizeConfig.dart';
import 'package:givnotes/pages/loginPage.dart';
import 'package:givnotes/ui/splashscreen.dart';
import 'package:givnotes/pages/home.dart';
import 'package:givnotes/utils/lockscreen.dart';
import 'package:givnotes/utils/login.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as Path;
import 'package:preferences/preference_service.dart';
// import 'package:provider/provider.dart';

// import 'database/moor_database.dart';

// TODO: change icons and black/white theme
void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      if (Platform.isAndroid) SystemNavigator.pop();
    }
  };
  // Hive
  WidgetsFlutterBinding.ensureInitialized();
  final appDir = await Path.getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  prefsBox = await Hive.openBox('prefs');
  //
  runApp(
    AppLock(
      builder: (_) => MyApp(),
      lockScreen: Lockscreen(changePassAuth: false),
      enabled: prefsBox.get('applock') ?? false,
    ),
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints);

        // return Provider(
        // create: (_) => GivnotesDatabase(),
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // showPerformanceOverlay: true,
          home: SplashScreen(
            seconds: 1,
            navigateAfterSeconds: CheckLogIn(),
            backgroundColor: Colors.white,
          ),
        );
        // );
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

    checkKeys();
    initInfo();
    PrefService.init(prefix: 'pref_');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (isSkipped == true) return HomePage();

        if (snapshot.connectionState == ConnectionState.waiting) return Scaffold(backgroundColor: Colors.black);

        if (!snapshot.hasData || snapshot.data == null) return LoginPage();

        //! Check on profile init state
        if (snapshot.hasData) currentUser = snapshot.data;
        getUserDetails();

        return HomePage();
      },
    );
  }

  void checkKeys() {
    if (!prefsBox.containsKey('skip')) {
      prefsBox.put('skip', false);
    } else {
      isSkipped = prefsBox.get('skip');
    }

    if (!prefsBox.containsKey('firstLaunch')) {
      prefsBox.put('firstLaunch', true);
    } else {
      isFirstLaunch = prefsBox.get('firstLaunch');
    }

    if (!prefsBox.containsKey('applock')) {
      prefsBox.put('applock', false);
    }
    if (!prefsBox.containsKey('biometric')) {
      prefsBox.put('biometric', false);
    }
  }
}

// getSkip().then((bool skip) {
//   if (skip == true || skip == false)
//     isSkipped = skip;
//   else
//     isSkipped = false;
// });
// _localPath.then((value) => Directory("$value/notes").create());
