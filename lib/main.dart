import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/configs/routes_config.dart';
import 'package:todo_list/configs/theme_config.dart';
import 'package:todo_list/services/local_notification.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>(
            create: (context) => NotificationService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkNotifications();
  }

  checkNotifications() async {
    await Provider.of<NotificationService>(context, listen: false)
        .checkForNotifications();
  }

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
