import 'package:flutter/material.dart';
import 'package:socaillogin/screens/intro_screen/introduction_screen.dart';
import 'package:socaillogin/screens/sign_in/sign_in_screen.dart';
import 'package:socaillogin/screens/sign_up/sign_up_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(IntroScreen.routeName, (route) => false);
    });

    super.initState();
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
