// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';

import '../main.dart';
import '../screens/screens.dart';

class Routes {
  static const String checkLogin = '/check-login';
  static const String homePage = '/home';
  static const all = <String>{
    checkLogin,
    homePage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.checkLogin, page: CheckLogin),
    RouteDef(Routes.homePage, page: HomePage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    CheckLogin: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const CheckLogin(),
        settings: data,
      );
    },
    HomePage: (data) {
      return buildAdaptivePageRoute<dynamic>(
        builder: (context) => const HomePage(),
        settings: data,
      );
    },
  };
}
