import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Global {
  static late SharedPreferences _prefs;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
  }

  ///获取本机是否设置密码
  static get isSetPsd => _prefs.getString('isSetPsd');

  ///获取本机设置的密码
  static get psd => _prefs.getInt('psd');
}
