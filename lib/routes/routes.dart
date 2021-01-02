import 'package:auto_route/auto_route_annotations.dart';
import 'package:givnotes/main.dart';
import 'package:givnotes/screens/screens.dart';

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AdaptiveRoute(page: CheckLogin, path: '/check-login'),
    AdaptiveRoute(page: HomePage, path: '/home'),
  ],
)
class $Router {}
