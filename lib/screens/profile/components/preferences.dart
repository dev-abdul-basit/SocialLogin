import 'package:flutter/material.dart';
import 'package:socaillogin/screens/edit_profile/edit_profile_screen.dart';

import '../../../components/custom_logout_dialog.dart';
import '../../../constants.dart';

class ProfilePreferences extends StatefulWidget {
  const ProfilePreferences({Key? key}) : super(key: key);

  @override
  State<ProfilePreferences> createState() => _ProfilePreferencesState();
}

class _ProfilePreferencesState extends State<ProfilePreferences> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(
                        isEdit: true,route: 'editProfile',
                      ),
                    ));
              },
              child: ListTile(
                title: const Text(
                  'Edit Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kTextColor,
                      fontSize: 15),
                ),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kTextColorSecondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: kTextColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kTextColor,
                  size: 12,
                ),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: kTextColor,
                        fontSize: 15),
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: kTextColorSecondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: kTextColor,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: kTextColor,
                    size: 12,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kTextColor,
                      fontSize: 15),
                ),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kTextColorSecondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.privacy_tip,
                    color: kTextColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kTextColor,
                  size: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kTextColor,
                      fontSize: 15),
                ),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kTextColorSecondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.pages_rounded,
                    color: kTextColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kTextColor,
                  size: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      // Navigator.of(context).pop();

                      return CustomLogoutDialog(
                        press: () async {
                          Navigator.of(context).pop();
                        },
                        close: () {
                          Navigator.of(context).pop();
                        },
                      );
                    });
              },
              child: const ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: kTextColor,
                      fontSize: 15),
                ),
                leading: SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.logout,
                    color: kTextColor,
                  ),
                ),
                // trailing: const Icon(
                //   Icons.arrow_forward_ios_rounded,
                //   color: kTextColor,
                //   size: 12,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
