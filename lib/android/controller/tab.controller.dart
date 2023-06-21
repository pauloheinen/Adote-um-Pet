import 'package:adote_um_pet/android/pages/adopt.page.dart';
import 'package:adote_um_pet/android/pages/chat.page.dart';
import 'package:adote_um_pet/android/pages/profile.page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentViewIndex = 0;

  final List<Widget> _views = [
    const ProfilePage(),
    const AdoptPage(),
    const ChatPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentViewIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Care Me app")),
      body: _views[_currentViewIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.greenAccent,
        onTap: onTabTapped,
        currentIndex: _currentViewIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            backgroundColor: Colors.white,
            label: "Meu perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            backgroundColor: Colors.white,
            label: "Pets",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            backgroundColor: Colors.white,
            label: "Chat",
          )
        ],
      ),
    );
  }
}
