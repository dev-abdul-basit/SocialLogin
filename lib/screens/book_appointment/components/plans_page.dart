import 'package:flutter/material.dart';
import 'package:socaillogin/components/primary_button.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/screens/book_appointment/components/confirmation_dialog.dart';
import 'package:socaillogin/screens/book_appointment/components/schedule_apointmnt_dialog.dart';
import 'package:socaillogin/screens/home/homepage.dart';
import 'package:socaillogin/size_config.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: getProportionateScreenHeight(0)),
          Text('Our Best Plans', style: headingStyle),
          SizedBox(height: getProportionateScreenHeight(16)),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff071a2f),
                    Color.fromARGB(255, 140, 156, 180),
                  ],
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: getProportionateScreenHeight(24)),
                Text(
                  'PLAN A',
                  style: headingStyleWhite1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                Text(
                  'Cost 1,000 INR',
                  style: headingStyleWhite2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Text(
                    'A. Includes: 1 Cryptocurrency with return potential of 400+% return',
                    style: headingStyleWhite3,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Text(
                    'B. 2 Indian Stocks with return potential of 80+% return',
                    style: headingStyleWhite3,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(16)),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Text(
                    'C. Estimated time 2-3 years',
                    style: headingStyleWhite3,
                    maxLines: 3,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(48)),
              ],
            ),
          ),
          Image.asset(
            'assets/images/book_appointment.jpeg',
            width: getProportionateScreenWidth(150),
            height: getProportionateScreenHeight(150),
          ),
          SizedBox(height: getProportionateScreenHeight(36)),
          PrimaryButton(
            press: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return DialogScheduleAppointment(
                      press: () {
                        print('clicked');
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DialogConfirmation(
                                details:
                                    'Your appointment is being confirmed  with Dr.Crypto on 3rd Sept',
                                subTitle: 'Your Appointment Successful',
                                title: 'Thank you!',
                                press: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      HomePage.routeName, (route) => false);
                                },
                              );
                            });
                      },
                      close: () {
                        Navigator.of(context).pop();
                      },
                    );
                  });
            },
            text: 'Payment / Book Appointment',
            color: kPrimaryColor,
            textColor: const Color(0xffffffff),
          )
        ],
      ),
    );
  }
}
