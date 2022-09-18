import 'package:flutter/material.dart';

import '../constants.dart';

class CustomLogoutDialog extends StatefulWidget {
  const CustomLogoutDialog({Key? key, required this.press, required this.close})
      : super(key: key);
  final Function press;
  final Function close;
  @override
  State<CustomLogoutDialog> createState() => _CustomLogoutDialogState();
}

class _CustomLogoutDialogState extends State<CustomLogoutDialog> {
  dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            InkWell(
              onTap: () {
                widget.close();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 200, bottom: 8),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: kTextColorSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.close),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: kPrimaryLightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 140,
                width: 140,
              ),
            ),
            const SizedBox(height: 48.0),
            const Text(
              "Are you sure you want to logout?",
              style: TextStyle(
                fontFamily: 'Poppins-Bold',
                fontSize: 16,
                color: kTextColor,
                height: 1.2,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                widget.press();
              },
              style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.fromLTRB(48, 12, 48, 12)),
              child: const Text(
                "Logout Now",
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 14,
                  color: Color(0xffffffff),
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
