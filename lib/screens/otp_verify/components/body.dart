import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/helper/global_config.dart';
import 'package:socaillogin/routes.dart';
import 'package:socaillogin/screens/edit_profile/edit_profile_screen.dart';
import 'package:socaillogin/screens/sign_up/sign_up_screen.dart';
import 'package:socaillogin/size_config.dart';

import '../../../constants.dart';

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

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  var code = '';
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  Color borderColor = kPrimaryColor.withOpacity(0.5);
  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = kPrimaryColor;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: kPrimaryColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(24)),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SvgPicture.string(
                        svgBG,
                        allowDrawingOutsideViewBox: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 32, 0.0, 0.0),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: SvgPicture.string(
                            svgImg,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 32, 8.0, 0.0),
                        child: Image.asset(
                          'assets/images/dclogo.png',
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    "Verification",
                    textAlign: TextAlign.start,
                    style: headingStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Enter the OTP code sent to ${SignUpScreen.phoneNumber}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                buildTimer(),
                SizedBox(height: getProportionateScreenHeight(24)),
                Directionality(
                  // Specify direction if desired
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: pinController,
                    focusNode: focusNode,
                    length: 6,
                    showCursor: true,

                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    validator: (value) {
                      return value == code ? null : 'Pin is incorrect';
                    },
                    // onClipboardFound: (value) {
                    //   debugPrint('onClipboardFound: $value');
                    //   pinController.setText(value);
                    // },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      code = value;
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                PrimaryButton(
                    text: 'Validate',
                    press: () async {
                      try {
                        formKey.currentState!.validate();
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                smsCode: code,
                                verificationId: SignUpScreen.verify);
                        await auth.signInWithCredential(credential);
                        Navigator.pushNamedAndRemoveUntil(context,
                            EditProfilePage.routeName, ((route) => false));
                      } catch (e) {
                        print('Wrong OTP');
                      }
                    },
                    color: kPrimaryColor,
                    textColor: kSecondaryColor),
                SizedBox(height: getProportionateScreenHeight(48.0)),
                const Center(
                  child: Text(
                    "Did not receive a code?",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 14,
                        color: kTextColorSecondary),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // OTP code resend
                      setState(() {
                        _start = 30;
                        startTimer();
                      });
                    },
                    child: const Text(
                      "RESEND OTP",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                        color: Colors.transparent,
                        decorationColor: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: kPrimaryColor, offset: Offset(0, -4))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
