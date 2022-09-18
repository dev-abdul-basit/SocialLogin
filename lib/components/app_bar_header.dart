import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
    required this.top,
    required this.left,
  }) : super(key: key);
  final double top, left;
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: getProportionateScreenHeight(130),
          decoration: const BoxDecoration(color: kPrimaryColor),
        ),
        Positioned(
          top: widget.top,
          left: widget.left,
          child: Container(
            height: 96.0,
            width: 96.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/user.png'),
                ),
                border: Border.all(color: const Color(0xffffffff), width: 2.0)),
          ),
        ),
        Positioned(
          top: 70,
          child: Text(
            'Abdul Basit',
            style: appBarHeadingStyle,
          ),
        ),
      ],
    );
  }
}
