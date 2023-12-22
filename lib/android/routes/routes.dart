import 'package:adote_um_pet/android/screens/conversations_page.dart';
import 'package:adote_um_pet/android/screens/create_account_page.dart';
import 'package:adote_um_pet/android/screens/login_page.dart';
import 'package:adote_um_pet/android/screens/pets_page.dart';
import 'package:adote_um_pet/android/screens/profile_page.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
  <String, WidgetBuilder>{
    '/conversation': (_) => const ConversationsPage(),
    '/createAccount': (_) => const CreateAccountPage(),
    '/loginPage': (_) => const LoginPage(),
    '/pets': (_) => PetsPage(),
    '/profile': (_) => const ProfilePage(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
