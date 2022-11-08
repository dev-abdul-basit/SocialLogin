import 'package:flutter/material.dart';
import 'package:socaillogin/helper/global_config.dart';
import 'package:socaillogin/screens/home/components/appointment_list.dart';
import 'package:socaillogin/size_config.dart';

import '../../../components/app_bar_header.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
         CustomAppBar(
          left: 25,
          top: 40,
          image: box!.get('photoUrl')=='empty'?userImage:box!.get('photoUrl'),
          name: box!.get('name')=='empty'?'':box!.get('name'),
        ),
        SizedBox(height: getProportionateScreenHeight(24)),
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(24.0),
              right: getProportionateScreenWidth(24.0)),
          child: Text(
            'BOOKED APPOINTMENT',
            style: headingStyleBA,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(8)),
        const Expanded(child: AppointmentList()),
      ],
    );
  }
}
