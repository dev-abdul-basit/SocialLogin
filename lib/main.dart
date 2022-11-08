import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/routes.dart';
import 'package:socaillogin/theme.dart';

import 'helper/global_config.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      statusBarColor: kPrimaryColor));
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentsDirectory.path);
  box = await Hive.openBox('easyLogin');
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
