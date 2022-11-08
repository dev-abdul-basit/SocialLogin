import 'package:flutter/material.dart';
import 'package:socaillogin/helper/global_config.dart';

import 'package:socaillogin/screens/profile/components/preferences.dart';
import 'package:socaillogin/screens/profile/components/profile_header.dart';
import 'package:socaillogin/size_config.dart';

import '../../components/custom_btm_bar.dart';
import '../../enum.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/profile';
  const ProfilePage({Key? key, required this.isEdit}) : super(key: key);
  final bool isEdit;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ProfileHeader(
            name: box!.get('name')=='empty'?'':box!.get('name'),
            profileImage: box!.get('photoUrl')=='empty'?userImage:box!.get('photoUrl'),
            backPress: () {},
            cameraPress: () {},
            isVisible: false,

          ),
          SizedBox(height: getProportionateScreenHeight(120)),
          const ProfilePreferences(),
        ],
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
