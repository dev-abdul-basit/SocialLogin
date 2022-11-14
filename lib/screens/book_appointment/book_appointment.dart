import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../components/app_bar_header.dart';
import '../../components/primary_button.dart';
import '../../constants.dart';
import '../../helper/global_config.dart';
import '../../size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socaillogin/components/custom_btm_bar.dart';
import 'package:socaillogin/enum.dart';
import '../../gCalender/calendar_client.dart';
import '../add_event_screen/add_event_screen.dart';
import 'components/schedule_apointmnt_dialog.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class BookAppointmentPage extends StatefulWidget {
  static String routeName = '/bookAppointment';
  const BookAppointmentPage({Key? key}) : super(key: key);

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  // function to implement the google signin
  // creating firebase instance
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child('Users');
  Future<void> signupWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[cal.CalendarApi.calendarScope]);
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn
        .signIn();
    if (googleSignInAccount != null) {
      print('here:1');
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      //Linking account
      try {
         UserCredential? userCredential = await auth.currentUser
            ?.linkWithCredential(authCredential).then((value) async {

          var httpClient = (await googleSignIn.authenticatedClient())!;
          CalendarClient.calendar = cal.CalendarApi(httpClient);
          return null;
        });
        // UserCredential result = await auth.signInWithCredential(
        //     authCredential);
        // user = auth.currentUser!.providerData;



        print( user!.email);
        if(user != null ) {
          // await _databaseReference
          //     .child(user!.uid.toString())
          //     .update({
          //   "email": user.email,
          // });
          box!.put('isGoogleCalender', 'true');
          gotoAddEventScreen();
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            gotoAddEventScreen();

            print("The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            print("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            print("The account corresponding to the credential already exists, "
                "or is already linked to a Firebase User.");
            break;
        // See the API reference for the full list of error codes.
          default:
            print("Unknown error.");
        }
      }
    }
  }
  gotoAddEventScreen (){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddEventScreen()));
  }

  @override
  void initState() {

    super.initState();
    print('box');
    print(box!.get('isGoogleCalender'));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(children:  <Widget>[
        CustomAppBar(
          left: 25,
          image: box!.get('photoUrl')=='empty'?userImage:box!.get('photoUrl'),
          top: 30,
          name: box!.get('name'),
        ),
        Expanded(
            child: SingleChildScrollView(
                physics:const BouncingScrollPhysics(), child: Padding(
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
                                signupWithGoogle(context);
                                //gotoAddEventScreen();

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
            ))),
      ]),
      bottomNavigationBar:const CustomBottomNavBar(selectedMenu: MenuState.event),
    );
  }
}
