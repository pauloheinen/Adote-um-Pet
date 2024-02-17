import 'package:adote_um_pet/routes/routes.dart';
import 'package:adote_um_pet/screens/login_page.dart';
import 'package:adote_um_pet/themes/app_theme.dart';
import 'package:adote_um_pet/utilities/global.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Adote um pet",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData(),
      home: const LoginPage(),
      scaffoldMessengerKey: snackbarKey,
      navigatorKey: Routes.navigatorKey,
      routes: Routes.list,
    );
  }
}
