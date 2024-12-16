import 'package:flutter/material.dart';
import 'package:parkease/screens/HomeScreen/home_screen.dart';
import 'package:parkease/screens/MapScreen/mapscreen.dart';
import 'package:parkease/screens/auth/login.dart';
import 'package:parkease/screens/ProfileScreen/profilescreen.dart';
import 'package:parkease/screens/TransactionScreen/transactionscreen.dart';
import 'package:parkease/screens/ParkingSlots/ParkingSlotScreen.dart';

import '../screens/PaymentScreen/paymentscreen.dart'; // Import PaymentScreen

class AppRoutes {
  static const String home = '/home';
  static const String map = '/map';
  static const String transactions = '/transactions';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String parkingSlot = '/parkingSlot';
  static const String payment = '/payment'; // Define the payment route

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case transactions:
        return MaterialPageRoute(builder: (_) => const TransactionScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case parkingSlot:
        return MaterialPageRoute(builder: (_) => const ParkingSlotScreen());
      case payment:
        return MaterialPageRoute(
            builder: (_) => PaymentScreen()); // Add payment screen route
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
