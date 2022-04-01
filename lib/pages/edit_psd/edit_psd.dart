// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:gesture_password_widget/gesture_password_widget.dart';

class EditPsd extends StatefulWidget {
  const EditPsd({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditPsdState();
  }
}

const backgroundColor = Color(0xff252534);

class _EditPsdState extends State<EditPsd> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ///设置的第一次密码
  late List<int> _psd;

  ///第二次密码是否错误
  bool _hasError = false;

  ///控制第二次设置密码
  bool flag = false;
  Widget createNormalGesturePasswordView() {
    // print(_psd);
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
      color: backgroundColor,
      onComplete: (data) {
        // _psd = data;
        _psd = List.from(data);
        setState(() {
          flag = true;
        });
      },
    );
  }

  Widget createNormalGesturePasswordView2() {
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
      answer: _psd,
      color: backgroundColor,
      onComplete: (data) async {
        if (data.join('') == _psd.join('')) {
          var psd = _psd.join('');
          final SharedPreferences prefs = await _prefs;
          prefs.setString('isSetPsd', 'true');
          prefs.setString('psd', psd);
          Navigator.of(context).pushReplacementNamed('home');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('修改成功'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 1500),
          ));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          flag ? '再次设置图案进行确认' : '设置新的解锁图案',
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: Text(
                      _hasError ? '两次图案不一致' : '',
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
              child: flag
                  ? createNormalGesturePasswordView2()
                  : createNormalGesturePasswordView(),
            ),
          ],
        ),
      ),
    );
  }
}
