import 'package:flutter/material.dart';

import 'package:socaillogin/components/custom_btm_bar.dart';

import 'package:socaillogin/enum.dart';
import 'components/body.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
