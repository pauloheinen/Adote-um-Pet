import 'dart:io' show Platform;

import 'package:adote_um_pet/android/app.dart';
import 'package:adote_um_pet/android/utilities/custom_notification.dart';
import 'package:adote_um_pet/ios/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => Platform.isIOS
    ? runApp(const IOSApp())
    : runApp(MultiProvider(providers: [
  Provider<NotificationService>(
    create: (context) => NotificationService(),
  ),
], child: const AndroidApp()));
