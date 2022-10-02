import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/routes.dart';
import 'package:socaillogin/theme.dart';

import 'screens/splash_screen/splash_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      statusBarColor: kPrimaryColor));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Login',
      theme: theme(),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      // home: const SplashScreen(),
      routes: routes,
    );
  }
}
