// ignore_for_file: avoid_print

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';

class SetPsd extends StatefulWidget {
  const SetPsd({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SetPsdState();
  }
}

class _SetPsdState extends State<SetPsd> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置密码'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;
              prefs.setString('isSetPsd', 'true');
              prefs.setInt('psd', 123456789);
              Navigator.of(context).pushReplacementNamed('home');
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text('setPsd'),
      ),
      // floatingActionButton: ,
    );
  }
}
