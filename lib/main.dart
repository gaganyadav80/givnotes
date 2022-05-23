import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:givnotes/controllers/controllers.dart';
import 'package:givnotes/database/db_helper.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'packages/packages.dart';
import 'routes.dart' as rt;
import 'screens/screens.dart';
import 'screens/src/todo_timeline/todo_timeline.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init(DBHelper.dbName);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //TODO comment when release
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());

  initGetXControllers();

  final AuthenticationRepository authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(App(authenticationRepository: authenticationRepository));
}

class App extends StatelessWidget {
  const App({Key? key, required this.authenticationRepository}) : super(key: key);
  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          // BlocProvider<HydratedPrefsCubit>(create: (_) => HydratedPrefsCubit()),
          // BlocProvider<NoteStatusCubit>(create: (_) => NoteStatusCubit()),
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
          designSize: const Size(414, 896),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => AppLock(
            builder: (_) => const GivnotesApp(),
            lockScreen: const ShowLockscreen(changePassAuth: null),
            enabled: PrefsController.to.passcodeEnabled.value,
            // backgroundLockLatency: Duration(),
          ),
        ),
      ),
    );
  }
}

class GivnotesApp extends StatefulWidget {
  const GivnotesApp({Key? key}) : super(key: key);

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
        primaryColor: const Color(0xff006aff),
        inputDecorationTheme: const InputDecorationTheme(iconColor: Color(0xff006aff)),
        pageTransitionsTheme:
            const PageTransitionsTheme(builders: {TargetPlatform.android: ZoomPageTransitionsBuilder()}),
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: RemoveScrollGlow(),
          child: child!,
        );
      },
      onGenerateRoute: rt.Router.generateRoute,
      // initialRoute: '/',
    );
  }
}

class CheckLogin extends StatelessWidget {
  CheckLogin({Key? key}) : super(key: key);

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Get.find<NotesController>().sortby = PrefsController.to.sortBy.value;

    if (_currentUser == null) {
      return const LoginPage();
    } else {
      pluginInitializer(_currentUser!.uid);

      return const HomePage();
    }
  }
}
