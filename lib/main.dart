import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_list/configs/routes_config.dart';
import 'package:todo_list/configs/theme_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //add theme config to theme and dark theme
      theme: ThemeConfig.themeData,
      darkTheme: ThemeConfig.themeDataDark,
      themeMode: ThemeMode.system,
      navigatorKey: navigatorKey,
      routes: RoutesConfig.routes,
      initialRoute: RoutesConfig.initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
