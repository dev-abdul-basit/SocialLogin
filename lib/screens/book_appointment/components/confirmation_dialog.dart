import 'package:flutter/material.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/size_config.dart';

class DialogConfirmation extends StatefulWidget {
  const DialogConfirmation({
    Key? key,
    required this.press,
    required this.title,
    required this.details,
    required this.subTitle,
  }) : super(key: key);
  final Function press;

  final String title;
  final String details;

  final String subTitle;

  @override
  State<DialogConfirmation> createState() => _DialogConfirmationState();
}

class _DialogConfirmationState extends State<DialogConfirmation> {
  dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xff0BBE7D).withOpacity(0.1),
                borderRadius: BorderRadius.circular(48),
              ),
              child: const Icon(
                Icons.thumb_up_rounded,
                size: 64,
                color: Color(0xff0BBE7D),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: getProportionateScreenHeight(32),
                  color: kTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenHeight(22),
                color: kPrimaryColor.withOpacity(0.6),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              widget.details,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                color: kPrimaryColor.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              height: 60.0,
              child: Stack(
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        onSurface: kPrimaryColor,
                        textStyle: const TextStyle(
                          fontFamily: 'Poppins-Bold',
                          fontSize: 18,
                          color: Color(0xffffffff),
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                        side: const BorderSide(color: kPrimaryColor),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        minimumSize: Size.infinite,
                        maximumSize: Size.infinite),
                    onPressed: () {
                      widget.press();
                    },
                    child: const Text('DONE'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
