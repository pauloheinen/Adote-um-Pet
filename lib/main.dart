import 'dart:io' show Platform;
import 'package:adote_um_pet/android/app.dart';
import 'package:adote_um_pet/ios/app.dart';
import 'package:flutter/material.dart';

void main() => Platform.isIOS ? runApp(const IOSApp()) : runApp(const AndroidApp());