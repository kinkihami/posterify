import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Sharedstore {
  
  const Sharedstore._();
  static const _isLogged = 'isLogged';
  static const phone = 'phonenumber';

  static Future<void> setLoggedin(bool loggedvalue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLogged, loggedvalue);
  }

  static Future<bool?> getLoggedin() async {
    final prefs = await SharedPreferences.getInstance();
    log(prefs.getBool(_isLogged).toString());
    return prefs.getBool(_isLogged);
  }

  static Future<void> setphone(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(phone, number);
    log(prefs.getString(phone).toString());
  }

  static Future<String?> getphone() async {
    final prefs = await SharedPreferences.getInstance();
    log(prefs.getString(phone).toString());
    return prefs.getString(phone);
  }

}
