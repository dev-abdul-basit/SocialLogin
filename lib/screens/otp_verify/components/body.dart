import 'dart:async';

import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'otp_form.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Timer _timer;
  int _start = 30;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              const Text("We sent your code to +1 898 860 ***"),
              buildTimer(),
              const OtpForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              InkWell(
                onTap: () {
                  // OTP code resend
                  setState(() {
                    _start = 30;
                    startTimer();
                  });
                },
                child: const Text(
                  "Resend OTP Code",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in "),
        const SizedBox(width: 10),
        Text(
          '00 : $_start',
          style: const TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
}
