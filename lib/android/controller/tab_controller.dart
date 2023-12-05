import 'package:adote_um_pet/android/pages/adopt_page.dart';
import 'package:adote_um_pet/android/pages/my_pets_page.dart';
import 'package:adote_um_pet/android/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../pages/conversations_page.dart';
import '../pages/empty_page.dart';
import '../preferences/preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentViewIndex = 0;

  final List<Widget> _views = [
    const ProfilePage(),
    MyPetsPage(),
    const AdoptPage(),
    const ConversationsPage(),
  ];

  void onTabTapped(int index) {
    setState(() => _currentViewIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: const Text("Adote um Pet"),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Preferences.clearRememberMe();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              })),
      body: _views[_currentViewIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.greenAccent,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.greenAccent,
        onTap: onTabTapped,
        currentIndex: _currentViewIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Meu perfil"),
          BottomNavigationBarItem(
              icon: Icon(Icons.line_weight_sharp), label: "Meus Pets"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Adoções"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat")
        ],
      ),
    );
  }
}
