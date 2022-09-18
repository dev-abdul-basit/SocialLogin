import 'package:adobe_xd/pinned.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/components/secondary_button.dart';
import 'package:socaillogin/screens/home/homepage.dart';
import 'package:socaillogin/screens/sign_in/sign_in_screen.dart';
import 'package:socaillogin/size_config.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: getProportionateScreenHeight(24)),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SvgPicture.string(
                    _svg_ql305e,
                    allowDrawingOutsideViewBox: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 32, 0.0, 0.0),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: SvgPicture.string(
                        _svg_yh7jp8,
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
            const Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: Text(
                  'Dr. CRYPTO',
                  style: TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff07192e),
                    height: 1.2,
                  ),
                  textHeightBehavior:
                      TextHeightBehavior(applyHeightToFirstAscent: false),
                  softWrap: false,
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(24)),
            const SizedBox(
              child: Text(
                'Create a New Account',
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff07192e),
                  height: 1.2,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                softWrap: false,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(24)),
            SizedBox(
              child: Stack(
                children: <Widget>[
                  IntlPhoneField(
                    cursorColor: kPrimaryColor,
                    showDropdownIcon: true,
                    showCountryFlag: false,
                    dropdownIcon: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: kPrimaryColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type Your Phone Number',
                      hintStyle: const TextStyle(color: kTextColorSecondary),
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 16,
                        color: Color(0xffd1d1d1),
                        height: 1.5,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color(0xff071a2f)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color(0xff071a2f)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color(0xff071a2f)),
                      ),
                    ),
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                    onCountryChanged: (country) {
                      print('Country changed to: ' + country.name);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(8)),
            PrimaryButton(
              press: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomePage.routeName, (route) => false);
              },
              text: 'SIGN UP',
              color: kPrimaryColor,
              textColor: const Color(0xffffffff),
            ),
            SizedBox(height: getProportionateScreenHeight(16)),
            const Text.rich(
              TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  color: Color(0xff595959),
                  height: 1.2000000476837158,
                ),
                children: [
                  TextSpan(
                    text: 'By tapping Sign up you accept all \n',
                  ),
                  TextSpan(
                    text: 'terms ',
                    style: TextStyle(
                      fontFamily: 'Poppins-SemiBold',
                      color: Color(0xff363062),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'and ',
                  ),
                  TextSpan(
                    text: 'condition',
                    style: TextStyle(
                      fontFamily: 'Poppins-SemiBold',
                      fontWeight: FontWeight.w500,
                      color: Color(0xff363062),
                    ),
                  ),
                ],
              ),
              textHeightBehavior:
                  TextHeightBehavior(applyHeightToFirstAscent: false),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getProportionateScreenHeight(48)),
            SizedBox(height: getProportionateScreenHeight(48)),
            Row(children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: kTextColorSecondary.withOpacity(0.5),
                      height: 36,
                      thickness: 1.5,
                    )),
              ),
              const Text(
                "Already have an account?",
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 14,
                  color: kTextColorSecondary,
                  height: 1.2,
                ),
              ),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: kTextColorSecondary.withOpacity(0.5),
                      height: 36,
                      thickness: 1.5,
                    )),
              ),
            ]),
            SizedBox(height: getProportionateScreenHeight(8)),
            SecondaryButton(
              press: () {
                Navigator.pushNamed(context, SignInScreen.routeName);
              },
              text: 'SIGN IN',
            ),
          ],
        ),
      ),
    );
  }
}

const String _svg_yh7jp8 =
    '<svg viewBox="597.5 110.2 97.1 97.1" ><path  d="M 608.7020874023438 110.185302734375 C 608.7020874023438 110.185302734375 683.4130859375 110.185302734375 683.4130859375 110.185302734375 C 689.5723876953125 110.185302734375 694.6195068359375 115.2229995727539 694.6195068359375 121.3916015625 C 694.6195068359375 121.3916015625 694.6195068359375 196.1029052734375 694.6195068359375 196.1029052734375 C 694.6195068359375 202.2621002197266 689.5723876953125 207.3088989257812 683.4130859375 207.3088989257812 C 683.4130859375 207.3088989257812 608.7020874023438 207.3088989257812 608.7020874023438 207.3088989257812 C 602.5333862304688 207.3088989257812 597.4957885742188 202.2621002197266 597.4957885742188 196.1029052734375 C 597.4957885742188 196.1029052734375 597.4957885742188 121.3916015625 597.4957885742188 121.3916015625 C 597.4957885742188 115.2229995727539 602.5333862304688 110.185302734375 608.7020874023438 110.185302734375 C 608.7020874023438 110.185302734375 608.7020874023438 110.185302734375 608.7020874023438 110.185302734375 Z" fill="#07192e" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_ql305e =
    '<svg viewBox="532.4 59.3 202.6 170.8" ><path  d="M 545.6041259765625 193.5579986572266 C 533.7119750976562 171.1240997314453 519.0341186523438 125.3998031616211 555.460205078125 121.972900390625 C 600.9937133789062 117.6893997192383 613.40869140625 120.6396026611328 639.1141967773438 81.04029846191406 C 664.81982421875 41.44089889526367 723.3306884765625 56.13949966430664 731.4395141601562 124.0442962646484 C 739.5482788085938 191.9492034912109 734.7880859375 201.9467926025391 706.9144287109375 200.4902954101562 C 679.0408935546875 199.0339050292969 669.9373168945312 190.5113067626953 651.8007202148438 211.6389007568359 C 633.6641235351562 232.7664031982422 580.9158935546875 245.6694030761719 545.6041259765625 193.5579986572266 Z" fill="#f5f5f5" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
