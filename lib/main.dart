import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parkease/screens/auth/login.dart';

import 'Services/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //The root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
      initialRoute: AppRoutes.login, // Set the initial route to LoginScreen
      onGenerateRoute: AppRoutes.generateRoute, // Set up named route navigation
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
