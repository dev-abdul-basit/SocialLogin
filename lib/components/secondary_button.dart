import 'package:flutter/material.dart';
import 'package:socaillogin/constants.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.0,
      child: Stack(
        children: <Widget>[
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                foregroundColor: kPrimaryColor,
                disabledForegroundColor: kPrimaryColor.withOpacity(0.38),
                textStyle: const TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 18,
                  color: Color(0xffffffff),
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
                side: const BorderSide(color: kPrimaryColor),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                minimumSize: Size.infinite,
                maximumSize: Size.infinite),
            onPressed: () {
              press();
            },
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
