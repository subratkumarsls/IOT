import 'package:flutter/material.dart';
// Use only relative imports below (relative to this file's location)
import '../../pages/login.dart';
import '../../pages/signup.dart';
import '../../pages/home_page.dart';
import '../../pages/device_management_page.dart';
import '../../pages/billing_page.dart';
import '../../pages/forgot_password.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String devices = '/devices';
  static const String bills = '/bills';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password'; // Added this line

  static final routes = <String, WidgetBuilder>{
    login: (context) => const Login(),
    home: (context) => const HomePage(),
    devices: (context) => const DeviceManagementPage(),
    bills: (context) => const BillingPage(),
    signup: (context) => const SignUpPage(),
    forgotPassword: (context) => const ForgotPasswordPage(), // Added this line
  };
}
