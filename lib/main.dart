import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:givnotes/cubit/home_cubit/home_cubit.dart';
import 'package:givnotes/cubit/note_search_cubit/note_search_cubit.dart';

import 'cubit/cubits.dart';
import 'global/size_utils.dart';
import 'global/variables.dart';
import 'packages/packages.dart';
import 'screens/screens.dart';
import 'screens/src/todo_timeline/todo_timeline.dart';
import 'services/services.dart';
import 'routes.dart' as rt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // To match status bar color to app bar color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  //TODO comment when release
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());

  await initHiveDb();
  await pluginInitializer();

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(
    AppLock(
      builder: (_) => App(authenticationRepository: authenticationRepository),
      lockScreen: ShowLockscreen(changePassAuth: false),
      enabled: prefsBox.applock,
    ),
  );
}

class App extends StatelessWidget {
  const App({Key key, this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(key: key);
  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    initializeUtils(context);

    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
          BlocProvider<HydratedPrefsCubit>(create: (_) => HydratedPrefsCubit()),
          BlocProvider<NoteAndSearchCubit>(create: (_) => NoteAndSearchCubit()),
          BlocProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc(authenticationRepository: authenticationRepository)),
          BlocProvider<TodosBloc>(
            create: (context) => TodosBloc(
              todosRepository: FirebaseTodosRepository(),
            )..add(LoadTodos()),
          ),
        ],
        child: GivnotesApp(),
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
        accentColorBrightness: Brightness.light,
        toggleableActiveColor: Colors.blue,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: RemoveScrollGlow(),
          child: child,
        );
      },
      onGenerateRoute: rt.Router.generateRoute,
      initialRoute: '/',
      // home: const CheckLogin(),
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
        if (!snapshot.hasData || snapshot.data == null) return LoginPage();

        return const HomePage();
      },
    );
  }
}
