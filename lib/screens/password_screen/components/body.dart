import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:socaillogin/screens/home/homepage.dart';
import 'dart:math';
import '../../../constants.dart';
import '../../../helper/global_config.dart';
import '../../../helper/keyboard.dart';
import '../../../size_config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socaillogin/components/primary_button.dart';

import '../../edit_profile/edit_profile_screen.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController passwordctrl = TextEditingController();
  String? password;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    password = generatePassword();
    passwordctrl.text = password!;
  }

  @override
  void dispose() {
    passwordctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 24),
          child: Column(
            children: <Widget>[
              // SizedBox(height: getProportionateScreenHeight(24)),
              //  SizedBox(height: SizeConfig.screenHeight * 0.05),
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
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: Text(
                    'Set Your password',
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
              ),
              SizedBox(height: getProportionateScreenHeight(24)),

              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(8)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        password = generatePassword();
                        passwordctrl.text = password!;
                      },
                      child: const Text(
                        "Randomize",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Poppins-Bold',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff07192e),
                        ),
                      ),
                    ),
                    // SizedBox(width: getProportionateScreenHeight(24)),
                    InkWell(
                      onTap: () {
                        passwordctrl.text = '';
                      },
                      child: const Text(
                        "Clear",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: 'Poppins-Bold',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff07192e),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: PrimaryButton(
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() async {
                          try {
                            if (user != null) {
                              await _databaseReference
                                  .child(user!.uid.toString())
                                  .update({
                                "password": passwordctrl.text,
                              });
                              gotoNextScreen();
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        });
                        KeyboardUtil.hideKeyboard(context);
                      }
                    },
                    text: 'SAVE',
                    color: kPrimaryColor,
                    textColor: const Color(0xffffffff),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(24)),
            ],
          ),
        ),
      ),
    );
  }

  gotoNextScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditProfilePage(
            isEdit: true,
            route: 'firstLogin',
          ),
        ));
  }

  String generatePassword({
    bool letter = true,
    bool isNumber = true,
    bool isSpecial = true,
  }) {
    const length = 8;
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';

    String chars = "";
    if (letter) chars += '$letterLowerCase$letterUpperCase';
    if (isNumber) chars += number;
    if (isSpecial) chars += special;

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);
      return chars[indexRandom];
    }).join('');
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordctrl,
      autocorrect: false,
      obscureText: _obscureText,
      enableSuggestions: false,
      cursorColor: kPrimaryColor,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _formKey.currentState!.validate();
          });
        } else if (value.length >= 8) {
          setState(() {
            _formKey.currentState!.validate();
          });
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelText: "Password",
        hintText: 'Password',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        filled: false,
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        suffixIcon: GestureDetector(
          onTap: _toggle,
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: kTextColorSecondary,
          ),
        ),
      ),
    );
  }
}
