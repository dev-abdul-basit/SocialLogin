import 'package:flutter/material.dart';
import 'package:socaillogin/routes.dart';
import 'package:socaillogin/theme.dart';

import 'screens/splash_screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocer App',
      theme: theme(),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      // home: const SplashScreen(),
      routes: routes,
    );
  }
}
