import 'package:flutter/material.dart';
import 'package:socaillogin/screens/book_appointment/components/plans_page.dart';

import '../../../components/app_bar_header.dart';
import '../../../helper/global_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(children:  <Widget>[
      CustomAppBar(
        left: 25,
        image: box!.get('photoUrl')=='empty'?userImage:box!.get('photoUrl'),
        top: 30,
        name: box!.get('name'),
      ),
   const   Expanded(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(), child: PlansPage())),
    ]);
  }
}
