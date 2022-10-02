
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socaillogin/components/primary_button.dart';

import 'package:socaillogin/size_config.dart';


import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../home/homepage.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Initially password is obscure
  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextEditingController emailctrl = TextEditingController();
  TextEditingController passwordctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: getProportionateScreenHeight(24)),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SvgPicture.string(
                        _svgBG,
                        allowDrawingOutsideViewBox: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 32, 0.0, 0.0),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: SvgPicture.string(
                            _svgImg,
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
                      'Login',
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
                buildUsernameFormField(),
                SizedBox(height: getProportionateScreenHeight(16)),
                Visibility(visible: isVisible, child: buildPasswordFormField()),
                SizedBox(height: getProportionateScreenHeight(16)),
                PrimaryButton(
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {});
                      KeyboardUtil.hideKeyboard(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    }
                  },
                  text: 'LOG IN',
                  color: kPrimaryColor,
                  textColor: const Color(0xffffffff),
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 12,
                            color: kPrimaryColor),
                      ),
                    )
                  ],
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
                    "or Sign In with",
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
                SizedBox(height: getProportionateScreenHeight(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: getProportionateScreenHeight(60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                width: 1.0,
                                color: kPrimaryColor.withOpacity(0.2)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.facebook_rounded,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenHeight(4)),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: getProportionateScreenHeight(60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                width: 1.0,
                                color: kPrimaryColor.withOpacity(0.2)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.apple_outlined),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getProportionateScreenHeight(4)),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: getProportionateScreenHeight(60),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                width: 1.0,
                                color: kPrimaryColor.withOpacity(0.2)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.g_mobiledata_outlined,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: emailctrl,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => username = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _formKey.currentState!.validate();

            if (_formKey.currentState!.validate()) {
              isVisible = true;
            }
          });
        } else if (emailValidatorRegExp.hasMatch(value)) {
          _formKey.currentState!.validate();
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
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
        labelStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        focusColor: kPrimaryColor,
        labelText: "Username",
        hintText: 'Username',
        hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5)),
        fillColor: kFormColor,
        filled: false,
      ),
    );
  }
}

const String _svgImg =
    '<svg viewBox="597.5 110.2 97.1 97.1" ><path  d="M 608.7020874023438 110.185302734375 C 608.7020874023438 110.185302734375 683.4130859375 110.185302734375 683.4130859375 110.185302734375 C 689.5723876953125 110.185302734375 694.6195068359375 115.2229995727539 694.6195068359375 121.3916015625 C 694.6195068359375 121.3916015625 694.6195068359375 196.1029052734375 694.6195068359375 196.1029052734375 C 694.6195068359375 202.2621002197266 689.5723876953125 207.3088989257812 683.4130859375 207.3088989257812 C 683.4130859375 207.3088989257812 608.7020874023438 207.3088989257812 608.7020874023438 207.3088989257812 C 602.5333862304688 207.3088989257812 597.4957885742188 202.2621002197266 597.4957885742188 196.1029052734375 C 597.4957885742188 196.1029052734375 597.4957885742188 121.3916015625 597.4957885742188 121.3916015625 C 597.4957885742188 115.2229995727539 602.5333862304688 110.185302734375 608.7020874023438 110.185302734375 C 608.7020874023438 110.185302734375 608.7020874023438 110.185302734375 608.7020874023438 110.185302734375 Z" fill="#07192e" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svgBG =
    '<svg viewBox="532.4 59.3 202.6 170.8" ><path  d="M 545.6041259765625 193.5579986572266 C 533.7119750976562 171.1240997314453 519.0341186523438 125.3998031616211 555.460205078125 121.972900390625 C 600.9937133789062 117.6893997192383 613.40869140625 120.6396026611328 639.1141967773438 81.04029846191406 C 664.81982421875 41.44089889526367 723.3306884765625 56.13949966430664 731.4395141601562 124.0442962646484 C 739.5482788085938 191.9492034912109 734.7880859375 201.9467926025391 706.9144287109375 200.4902954101562 C 679.0408935546875 199.0339050292969 669.9373168945312 190.5113067626953 651.8007202148438 211.6389007568359 C 633.6641235351562 232.7664031982422 580.9158935546875 245.6694030761719 545.6041259765625 193.5579986572266 Z" fill="#f5f5f5" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
