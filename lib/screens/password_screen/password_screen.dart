import 'package:flutter/material.dart';

import '../../size_config.dart';
import 'components/body.dart';

class PasswordScreen extends StatelessWidget {
  static String routeName = "/createPassword";

  const PasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Set Password"),
      ),
      body: const Body(),
    );
  }
}
