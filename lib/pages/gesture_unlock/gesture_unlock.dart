// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gesture_password_widget/gesture_password_widget.dart';

class GestureUnLock extends StatefulWidget {
  const GestureUnLock({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _GestureUnLockState();
  }
}

const backgroundColor = Color(0xff252534);

class _GestureUnLockState extends State<GestureUnLock> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _hasError = false;
  late List<int> _psd;
  Future<List<int>> getPsd() async {
    final SharedPreferences prefs = await _prefs;
    final psd = prefs.getString('psd');
    if (psd != null) {
      ///获取密码，转换成int数组
      _psd = psd.split('').map((e) => int.parse(e)).toList();
    } else {
      _psd = [];
    }
    return _psd;
  }

  Widget createNormalGesturePasswordView() {
    return FutureBuilder(
      future: getPsd(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return GesturePasswordWidget(
          lineColor: const Color(0xff0C6BFE),
          errorLineColor: const Color(0xffFB2E4E),
          singleLineCount: 3,
          identifySize: 80.0,
          minLength: 4,
          normalItem: Icon(
            Icons.radio_button_unchecked,
            size: 40,
            color: Colors.white,
          ),
          selectedItem: Icon(
            Icons.radio_button_checked,
            size: 40,
            color: const Color(0xff0C6BFE),
            // color: Colors.green,
          ),
          errorItem: Icon(
            Icons.radio_button_checked,
            size: 40,
            color: const Color(0xffFB2E4E),
          ),
          answer: snapshot.data,
          color: backgroundColor,
          onComplete: (data) async {
            if (data.join('') == _psd.join('')) {
              Navigator.of(context).pushReplacementNamed('home');
            } else {
              setState(() {
                _hasError = true;
              });
            }
          },
          onHitPoint: () {
            setState(() {
              _hasError = false;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    '手势解锁',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    child: Text(
                      _hasError ? '图案错误，请重试' : '',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: const Color(0xffFB2E4E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: createNormalGesturePasswordView(),
            ),
          ],
        ),
      ),
    );
  }
}
