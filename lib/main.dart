import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:givnotes/cubit/home_cubit/home_cubit.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';
import 'package:givnotes/global/size_utils.dart';

import 'cubit/cubits.dart';
import 'global/variables.dart';
import 'packages/packages.dart';
import 'screens/screens.dart';
import 'services/services.dart';

void main() async {
  //TODO remove when release
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) {
      if (Platform.isAndroid) SystemNavigator.pop();
    }
  };
  //

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  EquatableConfig.stringify = kDebugMode;
  //TODO comment when done with bloc
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build();

  await initHiveDb();
  await pluginInitializer();

  runApp(
    AppLock(
      // builder: (_) => DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => GivnotesApp(),
      // ),
      // builder: (_) => App(authenticationRepository: AuthenticationRepository()),
      builder: (_) => App(),
      lockScreen: ShowLockscreen(changePassAuth: false),
      enabled: prefsBox.applock,
    ),
  );
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  //  assert(authenticationRepository != null),
  // final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    initializeUtils(context);

    // return RepositoryProvider.value(
    //   value: authenticationRepository,
    //   child:
    // );
    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (_) => AuthenticationBloc(authenticationRepository: authenticationRepository)),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => HydratedPrefsCubit()),
        BlocProvider(create: (_) => NoteAndSearchCubit()),
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => RegisterBloc()),
      ],
      child: GivnotesApp(),
    );
  }
}

class GivnotesApp extends StatelessWidget {
  // final _navigatorKey = GlobalKey<NavigatorState>();

  // NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'login_p': (context) => LoginPage(),
        'register_p': (context) => RegisterPage(),
        'verification_p': (context) => VerificationPage(),
        'home_p': (context) => HomePage(),
        'settings_p': (context) => SettingsPage(),
        'search_p': (context) => SearchPage(),
      },
      title: 'Givnotes',
      theme: ThemeData(
        //maybe switch to google fonts
        fontFamily: 'Poppins',
        accentColor: Colors.black,
        accentColorBrightness: Brightness.light,
        toggleableActiveColor: Colors.blue,
      ),
      // builder: (context, widget) => BlocListener<AuthenticationBloc, AuthenticationState>(
      //   child: widget,
      //   listener: (context, state) {
      //     switch (state.status) {
      //       case AuthenticationStatus.authenticated:
      //         _navigator.pushAndRemoveUntil<void>(
      //           HomePage.route(),
      //           (route) => false,
      //         );
      //         break;
      //       case AuthenticationStatus.unauthenticated:
      //         _navigator.pushAndRemoveUntil<void>(
      //           MaterialPageRoute(
      //             builder: (context) => BlocProvider(
      //               lazy: false,
      //               create: (_) => AuthCubit(context.read<AuthenticationRepository>()),
      //               child: GorgeousLoginPage(),
      //             ),
      //           ),
      //           (route) => false,
      //         );
      //         break;
      //       default:
      //         break;
      //     }
      //   },
      // ),
      // navigatorKey: _navigatorKey,
      // onGenerateRoute: (_) => HomePage.route(),
      home: const CheckLogin(),
    );
  }
}

class CheckLogin extends StatelessWidget {
  const CheckLogin({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CheckLogin());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Transform.scale(
            scale: 2.0,
            child: const CupertinoActivityIndicator(),
          );

        // if (prefsBox.isAnonymous) return const HomePage();

        //  || !snapshot.data.emailVerified
        if (!snapshot.hasData || snapshot.data == null)
          return BlocProvider(
            create: (context) => LoginBloc(),
            child: LoginPage(),
          );

        return const HomePage();
      },
    );
  }
}
