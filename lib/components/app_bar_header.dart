import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
    required this.top,
    required this.left,
    required this.name,
    required this.image
  }) : super(key: key);
  final double top, left;
  final String name,image;
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
            height: 72.0,
            width: 72.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image:  DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.image),
                ),
                border: Border.all(color: const Color(0xffffffff), width: 2.0)),
          ),
        ),
        Positioned(
          top: 70,
          left: 120,
          child: Text(
            widget.name,
            textAlign: TextAlign.start,
            style: appBarHeadingStyle,
          ),
        ),
      ],
    );
  }
}
