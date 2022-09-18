import 'package:flutter/material.dart';
import 'package:socaillogin/constants.dart';
import 'package:socaillogin/size_config.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<Map<String, String>> appointmentData = [
    {
      "status": "Booked",
      "date": "09-13-2022",
      "time": "09:00 AM",
      "remarks": "Some Remarks"
    },
    {
      "status": "Done",
      "date": "09-11-2022",
      "time": "02:00 AM",
      "remarks": "Some Remarks"
    },
    {
      "status": "Done",
      "date": "09-10-2022",
      "time": "10:00 AM",
      "remarks": "Some Remarks here"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ListView.builder(
          itemCount: appointmentData.length,
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
                          appointmentData[index]['status']!,
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
                          appointmentData[index]['date']!,
                          style: headingStyleh2,
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    Row(
                      children: <Widget>[
                        Text(
                          'Time: ',
                          style: headingStyleh1,
                        ),
                        Text(
                          appointmentData[index]['time']!,
                          style: headingStyleh2,
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenHeight(4)),
                    Row(
                      children: <Widget>[
                        Text(
                          'Remarks: ',
                          style: headingStyleh1,
                        ),
                        Text(
                          appointmentData[index]['remarks']!,
                          style: headingStyleh2,
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
    );
  }
}
