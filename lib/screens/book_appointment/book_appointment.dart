import 'package:flutter/material.dart';
import 'components/body.dart';
import '../../components/custom_btm_bar.dart';
import '../../enum.dart';

class BookAppointmentPage extends StatefulWidget {
  static String routeName = '/bookAppointment';
  const BookAppointmentPage({Key? key}) : super(key: key);

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.event),
    );
  }
}
