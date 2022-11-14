import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socaillogin/components/custom_btm_bar.dart';
import 'package:socaillogin/enum.dart';
import 'package:socaillogin/models/event_info.dart';
import '../../components/app_bar_header.dart';
import '../../constants.dart';
import '../../helper/global_config.dart';
import '../../models/user_model.dart';
import '../../size_config.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');
  var isLoading = false;
  var isLoadingEvent = false;
  var userData = [];
  List<UserModel> userModel = <UserModel>[];
  //////////////////////////////////////////
  //Event loading
  var eventData = [];
  List<EventInfo> eventModel = <EventInfo>[];
  String? time;


  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      getCurrentUser();
    } else {
      print('No User Found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                CustomAppBar(
                  left: 25,
                  top: 40,
                  image: box!.get('photoUrl') == 'empty'
                      ? userImage
                      : box!.get('photoUrl'),
                  name: box!.get('name') == 'empty' ? '' : box!.get('name'),
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                Padding(
                  padding: EdgeInsets.only(
                      left: getProportionateScreenWidth(24.0),
                      right: getProportionateScreenWidth(24.0)),
                  child: Text(
                    'BOOKED APPOINTMENT',
                    style: headingStyleBA,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(8)),
                Expanded(child: Builder(
                  builder: (context) {
                    return ListView.builder(
                      itemCount: eventModel.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            color: const Color(0xffD2F4F9),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Appointment Status: ',
                                      style: headingStyleh1,
                                    ),
                                    Text(
                                      eventModel[index].getStatus,
                                      style: headingStyleh2,
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.edit_calendar_outlined,
                                          color: kPrimaryColor,
                                        ))
                                  ],
                                ),
                                //SizedBox(height: getProportionateScreenHeight(4)),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Date: ',
                                      style: headingStyleh1,
                                    ),
                                    Text(
                                      eventModel[index].getDate,
                                      style: headingStyleh2,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(4)),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Time: ',
                                      style: headingStyleh1,

                                    ),
                                    Text(

                                      isLoadingEvent == false ?'':time!,
                                      style: headingStyleh2,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(4)),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Remarks: ',
                                      style: headingStyleh1,
                                    ),
                                    Text(
                                      eventModel[index].getLocation,
                                      style: headingStyleh2,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )),
              ],
            ),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  Future<void> getCurrentUser() async {
    _databaseReference.onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      userData.clear();
      userModel.clear();

      for (var data in snapshot.children) {
        userData.add(data.value);
      }

      setState(() {
        if (snapshot.exists && userData.isNotEmpty) {
          for (int x = 0; x < userData.length; x++) {
            if (userData[x]['id'] == user!.uid.toString()) {
              String id = userData[x]['id'].toString();
              String name = userData[x]['userName'];
              String phone = userData[x]['phone'];
              String email = userData[x]['email'];
              String address = userData[x]['address'];
              String photoUrl = userData[x]['photoUrl'];
              String status = userData[x]['status'];
              String token = userData[x]['token'];
              //Adding data to Hive
              box!.put("name", userData[x]['userName']);
              box!.put("phone", userData[x]['phone']);
              box!.put("email", userData[x]['email']);
              box!.put("address", userData[x]['address']);
              box!.put("photoUrl", userData[x]['photoUrl']);
              box!.put("status", userData[x]['status']);
              box!.put("token", userData[x]['token']);
              userModel.add(UserModel.editwithId(
                id,
                name,
                phone,
                email,
                address,
                photoUrl,
                status,
                token,
              ));
            }
            getEvents();
          }
          isLoading = true;
        } else {
          isLoading = false;
        }
      });
    });
  }
  //get events

  Future<void> getEvents() async {
    _databaseReference
        .child(user!.uid.toString())
        .child('events')
        .onValue
        .listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      eventData.clear();
      eventModel.clear();

      for (var data in snapshot.children) {
        eventData.add(data.value);
      }

      setState(() {
        if (snapshot.exists && eventData.isNotEmpty) {
          for (int x = 0; x < eventData.length; x++) {
            String id = eventData[x]['id'].toString();
            String name = eventData[x]['name'];
            String desc = eventData[x]['desc'];
            String loc = eventData[x]['loc'];
            String link = eventData[x]['link'];
            String date = eventData[x]['date'];
            List emails = eventData[x]['emails'];
            bool should_notify = eventData[x]['should_notify'];
            bool has_conferencing = eventData[x]['has_conferencing'];
            int start = eventData[x]['start'];
            int end = eventData[x]['end'];
            String status = eventData[x]['status'];
            var dt = DateTime.fromMillisecondsSinceEpoch(start);

             time = DateFormat('hh:mm a').format(dt);
            print(time);
            eventModel.add(EventInfo.withId(
              id,
              name,
              desc,
              loc,
              link,
              date,
              emails,
              should_notify,
              has_conferencing,
              start,
              end,
              status,
            ));
          }

          isLoadingEvent = true;

        } else {
          isLoadingEvent = false;
          print('No Events');
        }
      });
    });
  }
}
