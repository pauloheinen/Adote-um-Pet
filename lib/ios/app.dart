import 'package:adote_um_pet/ios/pages/home.page.dart';
import 'package:flutter/cupertino.dart';

class IOSApp extends StatelessWidget {
  const IOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: "Adote um Pet",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}