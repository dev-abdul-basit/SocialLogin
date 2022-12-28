import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/components/secondary_button.dart';
import 'package:socaillogin/helper/global_config.dart';
import 'package:socaillogin/screens/otp_verify/otp_verify_screen.dart';
import 'package:socaillogin/screens/sign_in/sign_in_screen.dart';

import '../../../constants.dart';
import '../../helper/keyboard.dart';
import '../../size_config.dart';
import '../home/homepage.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/signUp";
  static String verify = "";
  static String phoneNumber = "";

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController phoneCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        //Redirect to home
        print(user.uid);

        if (box!.containsKey("user_login")) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
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
                        keyboardType: TextInputType.number,
                        cursorColor: kPrimaryColor,
                        showDropdownIcon: true,
                        showCountryFlag: false,
                        dropdownIcon: const Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: kPrimaryColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type Your Phone Number',
                          hintStyle:
                              const TextStyle(color: kTextColorSecondary),
                          labelStyle: const TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontSize: 16,
                            color: Color(0xffd1d1d1),
                            height: 1.5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Color(0xff071a2f)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Color(0xff071a2f)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Color(0xff071a2f)),
                          ),
                        ),
                        onChanged: (phone) {
                          phoneCtrl.text = phone.completeNumber;
                          SignUpScreen.phoneNumber = phoneCtrl.text;
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
                  press: () async {
                    if (phoneCtrl.text != '' &&
                        formKey.currentState!.validate()) {
                      try {
                        KeyboardUtil.hideKeyboard(context);
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phoneCtrl.text,
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              const snackBar = SnackBar(
                                content: Text(
                                    'The provided phone number is not valid.'),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            SignUpScreen.verify = verificationId;
                            Navigator.pushNamed(context, OtpScreen.routeName);
                          },
                          timeout: const Duration(seconds: 60),
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } catch (e) {
                        const snackBar = SnackBar(
                          content: Text('Please enter a valid phone number!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      const snackBar = SnackBar(
                        content: Text('Please enter a valid phone number!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: 'SIGN UP',
                  color: kPrimaryColor,
                  textColor: kSecondaryColor,
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
        ),
      ),
    );
  }
}
