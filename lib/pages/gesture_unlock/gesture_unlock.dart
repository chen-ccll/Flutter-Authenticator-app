// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GestureUnLock extends StatefulWidget {
  const GestureUnLock({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _GestureUnLockState();
  }
}

class _GestureUnLockState extends State<GestureUnLock> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('解锁页面'),
        actions: [
          IconButton(
              onPressed: () async {
                final SharedPreferences prefs = await _prefs;
                final _psd = prefs.getInt('psd');
                if (_psd == 123456789) {
                  // print('unlock');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('解锁成功'),
                    backgroundColor: Colors.green,
                  ));
                  Navigator.of(context).pushReplacementNamed('home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('解锁失败'),
                    backgroundColor: Colors.red,
                  ));
                }
                //print(_psd);
              },
              icon: const Icon(Icons.lock_open)),
        ],
      ),
    );
  }
}
