import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:givnotes/screens/src/notes/src/notes_repository.dart';

import 'cubit/cubits.dart';
import 'packages/packages.dart';
import 'routes.dart' as rt;
import 'screens/screens.dart';
import 'screens/src/todo_timeline/todo_timeline.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //TODO comment when release
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());

  initGetXControllers();
  await initHiveDb();

  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}

class App extends StatelessWidget {
  const App({Key key, this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(key: key);
  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
          BlocProvider<HydratedPrefsCubit>(create: (_) => HydratedPrefsCubit()),
          BlocProvider<NoteStatusCubit>(create: (_) => NoteStatusCubit()),
          BlocProvider<AuthenticationBloc>(
            create: (_) => AuthenticationBloc(authenticationRepository: authenticationRepository),
          ),
          BlocProvider<TodosBloc>(
            create: (context) => TodosBloc(
              todosRepository: FirebaseTodosRepository(),
            )..add(LoadTodos()),
          ),
        ],
        child: ScreenUtilInit(
          designSize: Size(414, 896),
          builder: () => AppLock(
            builder: (_) => GivnotesApp(),
            lockScreen: ShowLockscreen(changePassAuth: null),
            enabled: VariableService().prefsBox.passcode.isNotEmpty,
            // backgroundLockLatency: Duration(),
          ),
        ),
      ),
    );
  }
}

class GivnotesApp extends StatefulWidget {
  const GivnotesApp({Key key}) : super(key: key);

  @override
  _GivnotesAppState createState() => _GivnotesAppState();
}

class _GivnotesAppState extends State<GivnotesApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Givnotes',
      theme: ThemeData(
        fontFamily: 'Poppins',
        accentColor: Colors.black,
        pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()}),
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: RemoveScrollGlow(),
          child: child,
        );
      },
      onGenerateRoute: rt.Router.generateRoute,
      // initialRoute: '/',
    );
  }
}

class CheckLogin extends StatelessWidget {
  final User _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Get.find<NotesController>().sortby = BlocProvider.of<HydratedPrefsCubit>(context).state.sortby;

    if (_currentUser == null) {
      return LoginPage();
    } else {
      pluginInitializer(_currentUser.uid);

      return HomePage();
    }

    // return StreamBuilder<User>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting)
    //       return Scaffold(
    //         backgroundColor: Colors.white,
    //         body: Center(
    //           child: CircularLoading(size: 50.0),
    //         ),
    //       );

    //     if (!snapshot.hasData || snapshot.data == null) return LoginPage();

    //     pluginInitializer(snapshot.data.uid);
    //     initHiveDb();

    //     return HomePage();
    //   },
    // );
  }
}
