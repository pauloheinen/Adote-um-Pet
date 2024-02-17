import 'package:adote_um_pet/controllers/tab_controller.dart';
import 'package:adote_um_pet/screens/conversations_page.dart';
import 'package:adote_um_pet/screens/create_account_page.dart';
import 'package:adote_um_pet/screens/login_page.dart';
import 'package:adote_um_pet/screens/pets_page.dart';
import 'package:adote_um_pet/screens/profile_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
  <String, WidgetBuilder>{
    '/conversation': (_) => const ConversationsPage(),
    '/createAccount': (_) => CreateAccountPage(),
    '/loginPage': (_) => const LoginPage(),
    '/pet': (_) => PetsPage(),
    '/profile': (_) => const ProfilePage(),
    '/homePage': (_) => const HomePage(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void replaceTo(String routeName, BuildContext context) {
      navigatorKey.currentState?.pushReplacementNamed(routeName);
  }
}
