import 'package:adote_um_pet/android/pages/adopt.page.dart';
import 'package:adote_um_pet/android/pages/chat.page.dart';
import 'package:adote_um_pet/android/pages/my.pets.page.dart';
import 'package:adote_um_pet/android/pages/profile.page.dart';
import 'package:flutter/material.dart';

import '../pages/login.page.dart';
import '../preferences/preferences.dart';
import '../utilities/Navigator/navigator.util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentViewIndex = 0;

  final List<Widget> _views = [
    const ProfilePage(),
    const MyPetsPage(),
    const AdoptPage(),
    const ChatPage(),
  ];

  void onTabTapped(int index) {
    setState(() => _currentViewIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Care Me app"),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Preferences.clearRememberMe();
                NavigatorUtil.pushAndRemoveTo(context, const LoginPage());
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
