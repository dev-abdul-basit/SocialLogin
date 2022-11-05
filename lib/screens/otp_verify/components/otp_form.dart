import 'package:flutter/material.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/screens/password_screen/password_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Form(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(56),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: false,
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      nextField(value, pin2FocusNode!);
                    },
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(56),
                  child: TextFormField(
                    focusNode: pin2FocusNode,
                    obscureText: false,
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin3FocusNode!),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(56),
                  child: TextFormField(
                    focusNode: pin3FocusNode,
                    obscureText: false,
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) => nextField(value, pin4FocusNode!),
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(56),
                  child: TextFormField(
                    focusNode: pin4FocusNode,
                    obscureText: false,
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: otpInputDecoration,
                    onChanged: (value) {
                      if (value.length == 1) {
                        pin4FocusNode!.unfocus();
                        // Then you need to check is the code is correct or not
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.15),
            PrimaryButton(
              text: "Continue",
              press: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PasswordScreen.routeName, (route) => false);
              },
              color: kPrimaryColor,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
