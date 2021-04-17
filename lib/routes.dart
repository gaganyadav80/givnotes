import 'package:flutter/material.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/screens/src/editor/editor_screen.dart';
import 'package:givnotes/screens/src/todo_timeline/create_todo.dart';
import 'package:givnotes/services/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'screens/screens.dart';

abstract class RouterName {
  static const String root = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String signupRouter = '/register';
  static const String verificationRoute = '/verification';
  static const String searchRoute = '/search';
  static const String editorRoute = '/editor';
  static const String aboutRoute = '/about';
  static const String contactRoute = '/contact';
  static const String profileRoute = '/profile';
  static const String lockscreenRoute = '/lockscreen';
  static const String addlockRoute = '/addlockscreen';
  static const String notesviewRoute = '/notes-view';
  static const String createTodoRoute = '/create-todo';
}

abstract class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.root:
        return MaterialWithModalsPageRoute(builder: (_) => CheckLogin());
      case RouterName.homeRoute:
        return MaterialWithModalsPageRoute(builder: (_) => HomePage());
      case RouterName.loginRoute:
        return MaterialWithModalsPageRoute(builder: (_) => LoginPage());
      case RouterName.signupRouter:
        return MaterialWithModalsPageRoute(builder: (_) => RegisterPage());
      case RouterName.verificationRoute:
        return MaterialWithModalsPageRoute(builder: (_) => VerificationPage());
      case RouterName.searchRoute:
        return MaterialWithModalsPageRoute(builder: (_) => SearchPage());
      case RouterName.editorRoute:
        List<dynamic> data = settings.arguments;
        return MaterialWithModalsPageRoute(builder: (_) => EditorScreen(noteMode: data[0], note: data[1]));
      case RouterName.aboutRoute:
        return MaterialWithModalsPageRoute(builder: (_) => AboutGivnotes());
      case RouterName.contactRoute:
        return MaterialWithModalsPageRoute(builder: (_) => ContactGivnotes());
      case RouterName.profileRoute:
        return MaterialWithModalsPageRoute(builder: (_) => MyProfile());
      case RouterName.lockscreenRoute:
        bool data = settings.arguments as bool;
        return MaterialWithModalsPageRoute(builder: (_) => ShowLockscreen(changePassAuth: data));
      case RouterName.addlockRoute:
        return MaterialWithModalsPageRoute(builder: (_) => AddLockscreen());
      case RouterName.notesviewRoute:
        return MaterialWithModalsPageRoute(builder: (_) => NotesView());
      case RouterName.createTodoRoute:
        List<dynamic> data = settings.arguments;
        return MaterialWithModalsPageRoute(
            builder: (_) => CreateTodoBloc(
                  isEditing: data[0],
                  id: data[1],
                  todo: data[2],
                ));
      default:
        return MaterialWithModalsPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
