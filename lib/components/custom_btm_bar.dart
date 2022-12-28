import 'package:flutter/material.dart';
import 'package:socaillogin/screens/book_appointment/book_appointment.dart';
import 'package:socaillogin/screens/home/homepage.dart';
import 'package:socaillogin/screens/portfolio/portfolio_screen.dart';
import 'package:socaillogin/screens/profile/profilepage.dart';

import '../constants.dart';
import '../enum.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.widgets_outlined,
                        color: MenuState.home == selectedMenu
                            ? kPrimaryColor
                            : inActiveIconColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomePage.routeName, (route) => false);

                        // Navigator.pushNamed(context, HomeScreen.routeName);
                      }),
                  Container(
                    child: MenuState.home == selectedMenu
                        ? Visibility(
                            visible: true,
                            child: mContainer(),
                          )
                        : Visibility(
                            visible: false,
                            child: mContainer(),
                          ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.credit_card_outlined,
                      color: MenuState.event == selectedMenu
                          ? kPrimaryColor
                          : inActiveIconColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, BookAppointmentPage.routeName);
                    },
                  ),
                  Container(
                    child: MenuState.event == selectedMenu
                        ? Visibility(visible: true, child: mContainer())
                        : Visibility(
                            visible: false,
                            child: mContainer(),
                          ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.bar_chart_rounded,
                      color: MenuState.portfolio == selectedMenu
                          ? kPrimaryColor
                          : inActiveIconColor,
                    ),
                    onPressed: () { Navigator.pushNamed(context, PortfolioScreen.routeName);},
                  ),
                  Container(
                    child: MenuState.portfolio == selectedMenu
                        ? Visibility(visible: true, child: mContainer())
                        : const Visibility(
                            visible: false,
                            child: Text("Portfolio"),
                          ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.person_outline_rounded,
                        color: MenuState.profile == selectedMenu
                            ? kPrimaryColor
                            : inActiveIconColor,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, ProfilePage.routeName);
                      }),
                  Container(
                    child: MenuState.profile == selectedMenu
                        ? Visibility(
                            visible: true,
                            child: mContainer(),
                          )
                        : Visibility(
                            visible: false,
                            child: mContainer(),
                          ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

Container mContainer() {
  return Container(
    height: 8,
    width: 48,
    decoration: const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(4.0),
        topLeft: Radius.circular(4.0),
      ),
    ),
  );
}
