import 'package:adote_um_pet/android/pages/adopt_page.dart';
import 'package:adote_um_pet/android/pages/conversations_page.dart';
import 'package:adote_um_pet/android/pages/create_account_page.dart';
import 'package:adote_um_pet/android/pages/empty_pet_page.dart';
import 'package:adote_um_pet/android/pages/empty_page.dart';
import 'package:adote_um_pet/android/pages/my_pets_page.dart';
import 'package:adote_um_pet/android/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
  <String, WidgetBuilder>{
    '/adopt': (_) => const AdoptPage(),
    '/conversation': (_) => const ConversationsPage(),
    '/createAccount': (_) => const CreateAccountPage(),
    '/emptyPage': (_) => EmptyPetPage(),
    '/loginPage': (_) => const LoginPage(),
    '/myPets': (_) => MyPetsPage(),
    '/profile': (_) => const ProfilePage(),
  };

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
