import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socaillogin/screens/home/homepage.dart';
import 'package:socaillogin/screens/intro_screen/introduction_screen.dart';

import '../../../helper/global_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        //Redirect to home
        print(user.uid);

        if (box!.containsKey("user_login")) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          });
        }
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(IntroScreen.routeName, (route) => false);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset(
        'assets/images/logo.png',
        width: 150,
        height: 150,
      ),
    );
  }
}
