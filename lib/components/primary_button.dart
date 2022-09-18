import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.text,
    required this.press,
    required this.color,
    required this.textColor,
  }) : super(key: key);
  final String text;
  final Function press;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.0,
      child: Stack(
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: color,
                onSurface: color,
                textStyle: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 18,
                  color: textColor,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
                side: BorderSide(color: color),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                minimumSize: Size.infinite,
                maximumSize: Size.infinite),
            onPressed: () {
              press();
            },
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins-Bold',
                fontSize: 18,
                color: textColor,
                height: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
