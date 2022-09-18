import 'package:flutter/material.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/size_config.dart';

class DialogScheduleAppointment extends StatefulWidget {
  const DialogScheduleAppointment({
    Key? key,
    required this.press,
    required this.close,
  }) : super(key: key);
  final Function press;
  final Function close;

  @override
  State<DialogScheduleAppointment> createState() =>
      _DialogScheduleAppointmentState();
}

class _DialogScheduleAppointmentState extends State<DialogScheduleAppointment> {
  dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 6.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        // To make the card compact
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffB21F25), width: 4)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/images/calender.jpeg',
                fit: BoxFit.cover,
                height: getProportionateScreenHeight(375),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            child: InkWell(
              onTap: () {
                widget.press();
              },
              child: Image.asset(
                'assets/images/btn.png',
                height: getProportionateScreenHeight(64),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                  onPressed: () {
                    widget.close();
                  },
                  icon: const Icon(Icons.close, color: Color(0xffB21F25))),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
