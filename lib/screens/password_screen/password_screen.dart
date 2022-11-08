import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class PasswordScreen extends StatelessWidget {
  static String routeName = "/createPassword";

  const PasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: const Body(),
    );
  }
}
