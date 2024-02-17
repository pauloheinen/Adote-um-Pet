import 'package:adote_um_pet/routes/routes.dart';
import 'package:adote_um_pet/screens/pets_page.dart';
import 'package:adote_um_pet/screens/profile_page.dart';
import 'package:flutter/material.dart';

import '../preferences/preferences.dart';
import '../screens/conversations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentViewIndex = 0;

  final List<Widget> _views = [
    const ProfilePage(),
    PetsPage(),
    const ConversationsPage(),
  ];

  void onTabTapped(int index) {
    setState(() => _currentViewIndex = index);
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Adote um Pet"),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,
          ),
          onPressed: () {
            _showPopupMenu(context);
          },
        ),
      ),
      body: _views[_currentViewIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentViewIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pets"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat")
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'sair',
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'sair') {
        Preferences.clearRememberMe();
        Preferences.clearUserData();
        Routes.replaceTo('/loginPage', context);
      }
    });
  }

}
