import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:socaillogin/models/notification_model.dart';

import '../../constants.dart';
import '../../size_config.dart';

class NotificationScreen extends StatefulWidget {
  static String routeName = "/notification";
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //Event loading
  var notificationData = [];
  List<NotificationModel> notiModel = <NotificationModel>[];
  final DatabaseReference _dbReference =
      FirebaseDatabase.instance.ref().child('Notifications');
  var isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      getNotifications();
    } else {
      print('No User Found');
    }
  }

  Future<void> updateStatus(int index) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("Notifications")
        .child(user!.uid.toString())
        .child('noti')
        .child(notiModel[index].id!);

    await ref.update({
      "viewed": true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NotiAppBar(
            press: () {},
            backPress: () {
              Navigator.of(context).pop();
            },
          ),
          ListView.builder(
              itemCount: notiModel.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    updateStatus(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Container(
                      color: !notiModel[index].viewed
                          ? kPrimaryColor.withOpacity(0.1)
                          : kTextColorSecondary.withOpacity(0.1),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: !notiModel[index].viewed
                                    ? kPrimaryColor
                                    : kPrimaryBGColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  !notiModel[index].viewed
                                      ? Icons.notifications
                                      : Icons.notification_important_outlined,
                                  color: notiModel[index].viewed
                                      ? kPrimaryColor.withOpacity(0.2)
                                      : kPrimaryBGColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  Text(
                                    notiModel[index].notiTitle,
                                    style: headingStyle,
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notiModel[index].notiDesc,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Bold',
                                      color: !notiModel[index].viewed
                                          ? kPrimaryColor.withOpacity(0.7)
                                          : kPrimaryColor.withOpacity(0.4),
                                      height: 1.5,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Future<void> getNotifications() async {
    _dbReference
        .child(user!.uid.toString())
        .child('noti')
        .onValue
        .listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      notificationData.clear();
      notiModel.clear();

      for (var data in snapshot.children) {
        notificationData.add(data.value);
      }
      if (mounted) {
        setState(() {
          if (snapshot.exists && notificationData.isNotEmpty) {
            for (int x = 0; x < notificationData.length; x++) {
              String id = notificationData[x]['id'].toString();
              String notiTitle = notificationData[x]['notiTitle'];
              String notiDescription = notificationData[x]['notiDescription'];
              String date = notificationData[x]['date'];
              String time = notificationData[x]['time'];
              bool viewed = notificationData[x]['viewed'];
              String status = notificationData[x]['status'];
              String token = notificationData[x]['token'];

              notiModel.add(NotificationModel.withId(
                id,
                notiTitle,
                notiDescription,
                date,
                time,
                viewed,
                status,
                token,
              ));
            }

            isLoading = true;
          } else {
            isLoading = false;
            print('No Notifications');
          }
        });
      }
    });
  }
}

class NotiAppBar extends StatelessWidget {
  const NotiAppBar({
    Key? key,
    required this.press,
    required this.backPress,
  }) : super(key: key);
  final Function press, backPress;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: getProportionateScreenHeight(130),
          decoration: const BoxDecoration(color: kPrimaryColor),
        ),
        Positioned(
          left: 8,
          top: 24,
          child: IconButton(
            onPressed: () {
              backPress();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: kPrimaryBGColor,
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 24,
          child: Text(
            'Notifications',
            textAlign: TextAlign.start,
            style: notiHeadingStyle,
          ),
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: InkWell(
            onTap: () {
              press();
            },
            child: Text(
              'Clear',
              textAlign: TextAlign.start,
              style: appBarHeadingStyle,
            ),
          ),
        ),
      ],
    );
  }
}
