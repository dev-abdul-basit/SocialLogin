import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
    required this.name,
    required this.notiPress,
    required this.image,
  }) : super(key: key);

  final String name, image;
  final Function notiPress;
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
          bottom: 24,
          left: 30,
          child: Container(
            height: 56.0,
            width: 56.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.image,
                  ),
                ),
                border: Border.all(color: const Color(0xffffffff), width: 2.0)),
          ),
        ),
        Positioned(
          bottom: 36,
          left: 96,
          child: Text(
            widget.name,
            textAlign: TextAlign.start,
            style: appBarHeadingStyle,
          ),
        ),
        Positioned(
            right: 24,
            bottom: 24,
            child: IconButton(
              onPressed: () {
                widget.notiPress();
              },
              icon: const Icon(
                Icons.notifications,
                color: kPrimaryBGColor,
              ),
            ))
      ],
    );
  }
}
