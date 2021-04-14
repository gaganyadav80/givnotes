import 'package:flutter/material.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/screens/src/editor/editor_screen.dart';
import 'package:givnotes/screens/src/todo_timeline/create_todo.dart';
import 'package:givnotes/services/services.dart';

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
        return MaterialPageRoute(builder: (_) => CheckLogin());
      case RouterName.homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case RouterName.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case RouterName.signupRouter:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case RouterName.verificationRoute:
        return MaterialPageRoute(builder: (_) => VerificationPage());
      case RouterName.searchRoute:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case RouterName.editorRoute:
        List<dynamic> data = settings.arguments;
        return MaterialPageRoute(builder: (_) => EditorScreen(noteMode: data[0], note: data[1]));
      case RouterName.aboutRoute:
        return MaterialPageRoute(builder: (_) => AboutGivnotes());
      case RouterName.contactRoute:
        return MaterialPageRoute(builder: (_) => ContactGivnotes());
      case RouterName.profileRoute:
        return MaterialPageRoute(builder: (_) => MyProfile());
      case RouterName.lockscreenRoute:
        bool data = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => ShowLockscreen(changePassAuth: data));
      case RouterName.addlockRoute:
        return MaterialPageRoute(builder: (_) => AddLockscreen());
      case RouterName.notesviewRoute:
        return MaterialPageRoute(builder: (_) => NotesView());
      case RouterName.createTodoRoute:
        List<dynamic> data = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => CreateTodoBloc(
                  isEditing: data[0],
                  id: data[1],
                  todo: data[2],
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
