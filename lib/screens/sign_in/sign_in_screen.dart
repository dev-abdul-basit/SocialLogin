import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:socaillogin/models/user_model.dart';

import '../../components/primary_button.dart';
import '../../constants.dart';
import '../../helper/global_config.dart';
import '../../helper/keyboard.dart';
import '../../size_config.dart';
import '../home/homepage.dart';
import '../otp_verify/otp_verify_screen.dart';
import '../sign_up/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/signIn";

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Initially password is obscure
  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  TextEditingController phoneCtrl = TextEditingController();

  TextEditingController emailctrl = TextEditingController();
  TextEditingController passwordctrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool isVisible = false;

  //check if user is available
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _localUser;
  //Firebase database Reference
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');
  String? mtoken = " ";

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(' User logged in!');
        //Redirect to home
        print(user.uid);

        if (box!.containsKey("user_login")) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          });
        }
      } else {
        print('No User logged in!');
      }
    });
  }

  //Google Login
//function for GoogleSignIn

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      print('here:1');
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      // SignIn
      final googleCred =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      bool? isNewUser = googleCred.additionalUserInfo?.isNewUser;
      //Linking account
      if (isNewUser!) {
        print('New User... will be added as new');
        _localUser = googleCred.user;
        await _localUser!.reload();
        _localUser = _auth.currentUser;
        _localUser!.uid;

        if (_localUser != null && isNewUser) {
          //function to add user to db
          saveDataToFirebase(googleSignInAccount.displayName!,
              googleSignInAccount.email, googleSignInAccount.photoUrl!);
        } else {
          print('Error. Can not add new user to DB');
        }
      } else {
        //LinkAccount to existing account
        linkAccount(authCredential);
      } //else
    } //googleSignIn
  } //function end

  gotoHomePage() {
    Navigator.pushNamedAndRemoveUntil(
        context, HomePage.routeName, (route) => false);
  }

  Future<void> saveDataToFirebase(
      String name, String email, String photoUrl) async {
    UserModel userModel = UserModel.editwithId(
      _localUser!.uid.toString(),
      name,
      _localUser!.phoneNumber.toString(),
      email,
      photoUrl,
      'false',
      mtoken!,
      '--',
      '--',
      '0',
    );
    await _databaseReference
        .child(_localUser!.uid)
        .set(userModel.toJsonEdit())
        .then((value) {
      box!.put('user_login', true);

      box!.put('uid', _localUser!.uid.toString());
      box!.put('name', name);
      box!.put('email', email);
      box!.put('contact', _localUser!.phoneNumber.toString());
      box!.put('address', 'empty');
      box!.put('status', 'false');
      box!.put('token', mtoken);
      box!.put('photoUrl', photoUrl);
      box!.put('price2', '--');
      box!.put('profitLoss', '--');
      box!.put('plStatus', '0');
    }).then((value) => gotoHomePage());
  }

  Future<void> linkAccount(AuthCredential authCredential) async {
    try {
      print('Linking User...');
      final linkCred = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(authCredential)
          .then((value) async {
        box!.put('user_login', true);
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          box!.put('user_login', true);
          gotoHomePage();
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          box!.put('user_login', true);
          gotoHomePage();
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      } //switch
    } //exception
  }

  //facebook login
  Future<void> loginWithFaceBook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    final facebookCred = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    bool? isNewUser = facebookCred.additionalUserInfo?.isNewUser;
    if (isNewUser!) {
      print('New User... will be added as new');
      _localUser = facebookCred.user;
      await _localUser!.reload();
      _localUser = _auth.currentUser;
      if (_localUser != null && isNewUser) {
        //function to add user to db
        saveDataToFirebase(_localUser!.displayName!, _localUser!.email!,
            _localUser!.photoURL!);
      } else {
        print('Error. Can not add new user to DB');
      }
    } else {
      linkAccount(facebookAuthCredential);
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
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
                  //////////////=====Sign in with username
                  // SizedBox(height: getProportionateScreenHeight(24)),
                  // buildUsernameFormField(),
                  // SizedBox(height: getProportionateScreenHeight(16)),
                  // Visibility(
                  //     visible: isVisible, child: buildPasswordFormField()),
                  // SizedBox(height: getProportionateScreenHeight(16)),
                  // PrimaryButton(
                  //   press: () {
                  //     if (_formKey.currentState!.validate()) {
                  //       _formKey.currentState!.save();
                  //       setState(() {});
                  //       KeyboardUtil.hideKeyboard(context);
                  //       Navigator.pushNamedAndRemoveUntil(
                  //           context, HomePage.routeName, (route) => false);
                  //     }
                  //   },
                  //   text: 'LOG IN',
                  //   color: kPrimaryColor,
                  //   textColor: const Color(0xffffffff),
                  // ),
                  // SizedBox(height: getProportionateScreenHeight(24)),
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
                          _formKey.currentState!.validate()) {
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
                            codeSent:
                                (String verificationId, int? resendToken) {
                              SignUpScreen.verify = verificationId;
                              Navigator.pushNamed(context, OtpScreen.routeName);
                            },
                            timeout: const Duration(seconds: 60),
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
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
                  Visibility(
                    visible: false,
                    child: Row(
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
                  ),
                  SizedBox(height: getProportionateScreenHeight(48)),
                  SizedBox(height: getProportionateScreenHeight(48)),
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                          margin:
                              const EdgeInsets.only(left: 10.0, right: 20.0),
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
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 10.0),
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
                          onTap: () {
                            loginWithFaceBook();
                          },
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
                          onTap: () {
                            signInWithGoogle(context);
                          },
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
