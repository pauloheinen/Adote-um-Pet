import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_entity.dart';

class Preferences {
  static const USER_LOGIN_DATA = "USER_LOGIN_DATA";
  static const REMEMBER_ME = "USER_REMEMBER_ME";
  static const CITY_OPTION = "ADOPT_CITY_OPTION";

  static void saveUserData(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Preferences.USER_LOGIN_DATA, json.encode(user));
  }

  static void saveRememberMe(bool remember) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(Preferences.REMEMBER_ME, remember);
  }

  static void clearRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(Preferences.REMEMBER_ME);
  }

  static void clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(Preferences.USER_LOGIN_DATA);
  }

  static Future<User> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonUser = prefs.getString(Preferences.USER_LOGIN_DATA);

    return User.fromJson(json.decode(jsonUser!));
  }

  static Future<bool?> isRemember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(Preferences.REMEMBER_ME);
  }

  static void saveIbgeCity(int city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(Preferences.CITY_OPTION, city);
  }

  static Future<int?> getIbgeCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(Preferences.CITY_OPTION);
  }
}
