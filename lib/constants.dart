import 'package:flutter/material.dart';

import 'size_config.dart';

//const kPrimaryBGColor = Color(0xFFF5F5F5);
const kPrimaryBGColor = Color(0xFFFFFCFC);
const kPrimaryColor = Color(0xff071a2f);

const kPrimaryLightColor = Color(0xff071a2f);
const kFormColor = Color(0xFFF6F6F6);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xff071a2f), Color(0xff071a2f)],
);
const kSecondaryColor = Color(0xFFFFFFFF);
const kTextColor = Color(0xFF000000);
const kTextColorSecondary = Color(0xFF949494);

const kAnimationDuration = Duration(milliseconds: 200);
final introTextStyle = TextStyle(
  fontFamily: 'Poppins-Bold',
  fontSize: getProportionateScreenHeight(16),
  color: const Color(0xffFFFFFF),
  fontWeight: FontWeight.w300,
);
final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(22),
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
  height: 1.5,
);
final headingStyleBA = TextStyle(
  fontSize: getProportionateScreenWidth(24),
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
  height: 1.5,
);
final headingStyleh1 = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontWeight: FontWeight.w900,
  fontFamily: 'Poppins-Bold',
  color: kPrimaryColor.withOpacity(0.8),
);
final headingStyleh2 = TextStyle(
  fontSize: getProportionateScreenWidth(16),
  fontWeight: FontWeight.w500,
  fontFamily: 'Poppins-Bold',
  color: kPrimaryColor,
);
final headingStyleWhite1 = TextStyle(
  fontSize: getProportionateScreenWidth(20),
  fontFamily: 'Poppins-Bold',
  color: const Color(0xffffffff),
  fontWeight: FontWeight.bold,
);
final headingStyleWhite2 = TextStyle(
  fontSize: getProportionateScreenWidth(16),
  fontFamily: 'Poppins-Bold',
  color: const Color(0xffffffff),
  fontWeight: FontWeight.bold,
);
final headingStyleWhite3 = TextStyle(
  fontSize: getProportionateScreenWidth(16),
  fontFamily: 'Poppins-Bold',
  color: const Color(0xffffffff),
  fontWeight: FontWeight.normal,
);
final appBarHeadingStyle = TextStyle(
  fontFamily: 'Poppins-Bold',
  fontSize: getProportionateScreenWidth(18),
  color: const Color(0xffffffff),
  height: 1.2,
  fontWeight: FontWeight.w500,
);
final notiHeadingStyle = TextStyle(
  fontFamily: 'Poppins-Bold',
  fontSize: getProportionateScreenWidth(28),
  color: const Color(0xffffffff),
  height: 1.2,
  fontWeight: FontWeight.w900,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter Valid username / Email";
const String kInvalidEmailError = "Please Enter Valid username / Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kNullNameError = "Please Enter Name";

final otpInputDecoration = InputDecoration(
  filled: true,
  fillColor: kFormColor,
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kPrimaryColor),
  );
}
