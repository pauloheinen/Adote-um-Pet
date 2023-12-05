import 'package:adote_um_pet/android/pages/login_page.dart';
import 'package:adote_um_pet/android/utilities/Global/global.dart';
import 'package:flutter/material.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Adote um pet",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
      scaffoldMessengerKey: snackbarKey,
    );
  }
}
