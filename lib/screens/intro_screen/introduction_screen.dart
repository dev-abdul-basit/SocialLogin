import 'package:flutter/material.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/screens/sign_up/sign_up_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:socaillogin/size_config.dart';
import '../../components/page_tranisation.dart';
import '../../helper/global_config.dart';

class IntroScreen extends StatefulWidget {
  static String routeName = "/intro";
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        top: true,
        child: IntroductionScreen(
          globalBackgroundColor: kPrimaryColor,
          pages: [
            PageViewModel(
                decoration: PageDecoration(
                  titleTextStyle: const TextStyle(color: Colors.white),
                  bodyTextStyle: introTextStyle,
                ),
                title: "Talk with experts",
                body:
                    "Get expert opinion for your crypto investments from our curated list of crypto experts",
                image: Image.asset(
                  introPage1,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                )),
            PageViewModel(
                decoration: PageDecoration(
                  titleTextStyle: const TextStyle(color: Colors.white),
                  bodyTextStyle: introTextStyle,
                ),
                title: "Book anytime",
                body:
                    "Select your convenient time to clear your crypto related doubts and issues.",
                image: Image.asset(
                  introPage2,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.5,
                )),
            PageViewModel(
              decoration: PageDecoration(
                titleTextStyle: const TextStyle(color: Colors.white),
                bodyTextStyle: introTextStyle,
              ),
              title: "Create your portfolio",
              body:
                  "Create your own portfolio of selected cryptos and watch for changes in it.",
              image: Image.asset(
                introPage3,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            PageViewModel(
              bodyWidget: Column(
                children: <Widget>[
                  Text(
                    'Dr. Crypto',
                    style: TextStyle(
                      fontFamily: 'Poppins-Bold',
                      fontSize: getProportionateScreenHeight(36),
                      color: const Color(0xffFFFFFF),
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(16)),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                    child: Text(
                      'We are here to help you invest better\nand make great returns',
                      textAlign: TextAlign.center,
                      style: introTextStyle,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(32)),
                ],
              ),
              decoration: const PageDecoration(
                titleTextStyle: TextStyle(color: Colors.white),
              ),
              title: "Welcome to,",
              image: Image.asset(
                introPage4,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              footer: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: PrimaryButton(
                  press: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        SlideRightRoute(
                          page: const SignUpScreen(),
                        ),
                        (route) => false);
                  },
                  text: 'GET STARTED',
                  color: Colors.white,
                  textColor: Colors.black,
                ),
              ),
            ),
          ],
          showDoneButton: true,
          showSkipButton: true,
          skip: const Icon(Icons.skip_next),
          next: const Icon(Icons.navigate_next),
          done: const Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: const Color(0xffffffff),
            color: Colors.white24,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          baseBtnStyle:
              TextButton.styleFrom(foregroundColor: const Color(0xffffffff)),
          onDone: () {
            Navigator.of(context).pushAndRemoveUntil(
                SlideRightRoute(
                  page: const SignUpScreen(),
                ),
                (route) => false);
          },
        ),
      ),
    );
  }
}
