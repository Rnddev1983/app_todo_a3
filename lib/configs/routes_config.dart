//config routes
import 'package:flutter/material.dart';
import 'package:todo_list/views/login_page.dart';
import 'package:todo_list/views/sign_up.dart';
import 'package:todo_list/views/task_page.dart';

class RoutesConfig {
  static String initialRoute = '/login';
  static Map<String, WidgetBuilder> routes = {
    '/login': (context) => const LoginPage(),
    '/task': (context) => const TaskPage(),
    '/sign-up': (context) => const SignUp(),
  };
}

//add navigator key

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
