import 'package:flutter/widgets.dart';
import 'package:socaillogin/screens/add_event_screen/add_event_screen.dart';
import 'package:socaillogin/screens/book_appointment/book_appointment.dart';
import 'package:socaillogin/screens/edit_profile/edit_profile_screen.dart';
import 'package:socaillogin/screens/home/homepage.dart';
import 'package:socaillogin/screens/intro_screen/introduction_screen.dart';
import 'package:socaillogin/screens/notifications/notifications_screen.dart';
import 'package:socaillogin/screens/otp_verify/otp_verify_screen.dart';
import 'package:socaillogin/screens/password_screen/password_screen.dart';
import 'package:socaillogin/screens/portfolio/portfolio_screen.dart';
import 'package:socaillogin/screens/profile/profilepage.dart';
import 'package:socaillogin/screens/sign_in/sign_in_screen.dart';
import 'package:socaillogin/screens/sign_up/sign_up_screen.dart';

import 'screens/splash_screen/splash_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  PasswordScreen.routeName: (context) => const PasswordScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  HomePage.routeName: (context) => const HomePage(),
  ProfilePage.routeName: (context) => const ProfilePage(isEdit: true),
  EditProfilePage.routeName: (context) =>
      const EditProfilePage(isEdit: true, route: ''),
  BookAppointmentPage.routeName: (context) => const BookAppointmentPage(),
  AddEventScreen.routeName: (context) => const AddEventScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  PortfolioScreen.routeName: (context) => const PortfolioScreen(),
};
