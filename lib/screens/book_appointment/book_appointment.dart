import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:socaillogin/components/custom_btm_bar.dart';
import 'package:socaillogin/enum.dart';
import 'package:socaillogin/models/notification_model.dart';
import 'package:socaillogin/utils/push_message.dart';
import 'package:socaillogin/utils/storage.dart';

import '../../components/app_bar_header.dart';
import '../../components/primary_button.dart';
import '../../constants.dart';
import '../../gCalender/calendar_client.dart';
import '../../helper/global_config.dart';
import '../../models/razorpay_response_model.dart';
import '../../models/user_model.dart';
import '../../size_config.dart';
import '../add_event_screen/add_event_screen.dart';
import '../notifications/notifications_screen.dart';
import 'components/schedule_apointmnt_dialog.dart';

class BookAppointmentPage extends StatefulWidget {
  static String routeName = '/bookAppointment';
  const BookAppointmentPage({Key? key}) : super(key: key);

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  // creating firebase instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user; // Firebase User
  var userData = [];
  var isLoading = false;
  List<UserModel> userModel = <UserModel>[];
  //////////////////////////////////////////
  //Firebase database Reference
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');

  //Defining scopes for Google Calender API
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: <String>[cal.CalendarApi.calendarScope]);

  GoogleSignInAccount? _currentUser;
  //Razor pay
  final _razorpay = Razorpay();
  var now = DateTime.now();
  var formatterDate = DateFormat('dd/MM/yy');
  var formatterTime = DateFormat('kk:mm');
  String? actualDate;
  String? actualTime;
  Storage storage = Storage();
  //plans
  int currentPage = 0;
  List<Map<String, String>> plansData = [
    {
      "heading": "Plan A",
      "cost": "1000",
      "A.": "Includes: 1 Cryptocurrency with return potential of 400+% return",
      "B.": "2 Indian Stocks with return potential of 80+% return",
      "C.": "Estimated time 2-3 years",
    },
    {
      "heading": "Plan B",
      "cost": "1500",
      "A.": "Includes: 2 Cryptocurrency with return potential of 400+% return",
      "B.": "2 Indian Stocks with return potential of 80+% return",
      "C.": "Estimated time 2-3 years",
    },
    {
      "heading": "Plan C",
      "cost": "2000",
      "A.": "Includes: 3 Cryptocurrency with return potential of 400+% return",
      "B.": "2 Indian Stocks with return potential of 80+% return",
      "C.": "Estimated time 2-3 years",
    },
  ];
  @override
  void initState() {
    super.initState();
    //current firebase user
    user = _firebaseAuth.currentUser;
    actualDate = formatterDate.format(now);
    actualTime = formatterTime.format(now);

    if (user != null) {
      getCurrentUser();
    } else {
      print('No User Found');
    }
    //razor pay
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//end
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

//razor pay
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    //updating firebase database

    updateStatus();
    saveNotificationToDB('Congratulations', 'Payment Success');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Payment Success!. Enjoy the App '),
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    saveNotificationToDB('Sorry', 'Payment Not Success');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    saveNotificationToDB('Alert', 'Payment with External Wallet');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  } //razor pay

  Future<dynamic> createOrder() async {
    var mapHeader = <String, String>{};
    mapHeader['Authorization'] =
        "Basic cnpwX3Rlc3RfUU0zajVVM01yS2JpNFA6WnhmTXZKdndaU0h3MVkwRWlseTgxM0dw";
    mapHeader['Accept'] = "application/json";
    mapHeader['Content-Type'] = "application/x-www-form-urlencoded";
    var map = <String, String>{};
    setState(() {
      map['amount'] = plansData[currentPage]['cost']!;
    });
    map['currency'] = "INR";
    map['receipt'] = "receipt1";
    print("map $map");
    var response = await http.post(Uri.https("api.razorpay.com", "/v1/orders"),
        headers: mapHeader, body: map);
    print("...." + response.body);
    if (response.statusCode == 200) {
      RazorpayOrderResponse data =
          RazorpayOrderResponse.fromJson(json.decode(response.body));
      openCheckout(data, plansData[currentPage]['cost']!,
          plansData[currentPage]['heading']!);
    } else {
      print("Something went wrong!");
    }
  }

  void openCheckout(
      RazorpayOrderResponse data, String amount, String name) async {
    var options = {
      'key': razorPayApiKey,
      'amount': amount,
      'name': name,
      'description': '',
      'order_id': '${data.id}',
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> updateStatus() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users");
    try {
      await ref.child(user!.uid.toString()).update({
        "status": 'true',
      }).then((value) => {
            box!.put('status', 'true'),
          });

      setState(() {
        bookAppointment();
        box!.put('status', 'true');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  saveNotificationToDB(String notiTitle, String notiDescription) async {
    String idGenerator() {
      final now = DateTime.now();
      return now.microsecondsSinceEpoch.toString();
    }

    NotificationModel notificationModel = NotificationModel.withId(
      idGenerator(),
      notiTitle,
      notiDescription,
      actualDate!,
      actualTime!,
      false,
      '0',
      '_token',
    );
    if (user != null) {
      await storage
          .storeNotiData(notificationModel, user!.uid.toString())
          .then((value) {
        SendPushMessage sendPushMessage = SendPushMessage();
        sendPushMessage.sendPushNotification(
            notiTitle, notiDescription, box!.get('token'));
      });
    } else {
      print('No User');
    }
  }

  //function for GoogleSignIn
  Future<void> signupWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    // if (googleSignInAccount != null) {
    print('here:1');
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    CalendarClient.calendar = cal.CalendarApi(httpClient);
    //Linking account
    try {
      final userCredential = await _firebaseAuth.currentUser
          ?.linkWithCredential(authCredential)
          .then((value) async {});
      print(_currentUser!.email);
      if (_currentUser != null) {
        await _databaseReference.child(box!.get('uid')).update({
          "email": _currentUser!.email,
        });

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
          gotoAddEventScreen();
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          gotoAddEventScreen();
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }

  gotoAddEventScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddEventScreen()));
  }

  Future<void> getCurrentUser() async {
    _databaseReference.onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      userData.clear();
      userModel.clear();

      for (var data in snapshot.children) {
        userData.add(data.value);
      }
      if (mounted) {
        setState(() {
          if (snapshot.exists && userData.isNotEmpty) {
            for (int x = 0; x < userData.length; x++) {
              if (userData[x]['id'] == user!.uid.toString()) {
                String id = userData[x]['id'].toString();
                String name = userData[x]['userName'];
                String phone = userData[x]['phone'];
                String email = userData[x]['email'];

                String photoUrl = userData[x]['photoUrl'];
                String status = userData[x]['status'];
                String token = userData[x]['token'];
                String price2 = userData[x]['price2'];
                String profitLoss = userData[x]['profitLoss'];
                String plStatus = userData[x]['plStatus'];

                //Adding data to Hive
                box!.put("uid", userData[x]['id']);
                box!.put("name", userData[x]['userName']);
                box!.put("phone", userData[x]['phone']);
                box!.put("email", userData[x]['email']);

                box!.put("photoUrl", userData[x]['photoUrl']);
                box!.put("status", userData[x]['status']);
                box!.put("token", userData[x]['token']);
                box!.put('price2', userData[x]['price2']);
                box!.put('profitLoss', userData[x]['profitLoss']);
                box!.put('plStatus', userData[x]['plStatus']);
                userModel.add(UserModel.editwithId(
                  id,
                  name,
                  phone,
                  email,
                  photoUrl,
                  status,
                  token,
                  price2,
                  profitLoss,
                  plStatus,
                ));
              }
            }
            isLoading = true;
          } else {
            isLoading = false;
          }
        });
      }
    });
  }

  ///
  ///launch Flow
  Future<void> bookAppointment() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogScheduleAppointment(
            press: () async {
              print('clicked');

              signupWithGoogle(context);
              // final GoogleSignInAccount? googleSignInAccount =
              //     await _googleSignIn.signIn();
              // // if (googleSignInAccount != null) {
              // print('here:1');
              // final GoogleSignInAuthentication googleSignInAuthentication =
              //     await googleSignInAccount!.authentication;
              // final AuthCredential authCredential =
              //     GoogleAuthProvider.credential(
              //         idToken: googleSignInAuthentication.idToken,
              //         accessToken: googleSignInAuthentication.accessToken);
              // var httpClient = (await _googleSignIn.authenticatedClient())!;
              // CalendarClient.calendar = cal.CalendarApi(httpClient);
            },
            close: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        CustomAppBar(
          notiPress: () {
            Navigator.pushNamed(context, NotificationScreen.routeName);
          },
          image: box!.get('photoUrl') == 'empty'
              ? userImage
              : box!.get('photoUrl'),
          name: box!.get('name'),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: getProportionateScreenHeight(0)),
                Text('Our Best Plans', style: headingStyle),
                SizedBox(height: getProportionateScreenHeight(16)),
                Expanded(
                  child: Container(
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
                    child: Builder(builder: (context) {
                      return PageView.builder(
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount: plansData.length,
                        itemBuilder: (context, index) => PlansContent(
                          heading: plansData[index]["heading"]!,
                          cost: "${plansData[index]['cost']!} INR",
                          a: plansData[index]['A.']!,
                          b: plansData[index]['B.']!,
                          c: plansData[index]['C.']!,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    plansData.length,
                    (index) => buildDot(index: index),
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
                    if (box!.get('status') == 'false') {
                      createOrder();
                    } else {
                      bookAppointment();
                    }
                  },
                  text: box!.get('status') == 'false'
                      ? 'Proceed to Pay'
                      : 'Book Appointment',
                  color: kPrimaryColor,
                  textColor: const Color(0xffffffff),
                )
              ],
            ),
          ),
        ),
      ]),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.event),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: 8,
      //width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PlansContent extends StatelessWidget {
  const PlansContent({
    Key? key,
    required this.heading,
    required this.cost,
    required this.a,
    required this.b,
    required this.c,
  }) : super(key: key);
  final String cost, heading, a, b, c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Spacer(),
        Text(
          heading,
          style: headingStyleWhite1,
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Text(
          cost,
          style: headingStyleWhite2,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16),
          child: Text(
            a,
            style: headingStyleWhite3,
            maxLines: 3,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16),
          child: Text(
            b,
            style: headingStyleWhite3,
            maxLines: 3,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16),
          child: Text(
            c,
            style: headingStyleWhite3,
            maxLines: 1,
            textAlign: TextAlign.start,
          ),
        ),
        Spacer(flex: 2),
      ],
    );
  }
}
