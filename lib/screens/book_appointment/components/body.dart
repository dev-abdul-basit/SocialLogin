import 'package:flutter/material.dart';
import 'package:socaillogin/screens/book_appointment/components/plans_page.dart';

import '../../../components/app_bar_header.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(children: const <Widget>[
      CustomAppBar(
        left: 25,
        top: 30,
      ),
      Expanded(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(), child: PlansPage())),
    ]);
  }
}
