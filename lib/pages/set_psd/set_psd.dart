// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:gesture_password_widget/gesture_password_widget.dart';
// import 'package:encrypt/encrypt.dart' as enCrypt;

class SetPsd extends StatefulWidget {
  const SetPsd({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SetPsdState();
  }
}

const backgroundColor = Color(0xff252534);

class _SetPsdState extends State<SetPsd> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ///设置的第一次密码
  late List<int> _psd;

  ///第二次密码是否错误
  String _hasError = '';

  ///控制第二次设置密码
  bool flag = false;
  Widget createNormalGesturePasswordView() {
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
      ),
      errorItem: Icon(
        Icons.radio_button_checked,
        size: 40,
        color: const Color(0xffFB2E4E),
      ),
      color: backgroundColor,
      onComplete: (data) {
        if (data.length > 4) {
          _psd = List.from(data);
          setState(() {
            flag = true;
          });
        } else {
          setState(() {
            _hasError = '密码至少连接4个点';
          });
        }
      },
      onHitPoint: () {
        setState(() {
          _hasError = '';
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
          // final key = enCrypt.Key.fromUtf8('AiP9h1GxDR38I1C9HzET1UCWqOUETxqv');
          // final iv = enCrypt.IV.fromLength(16);
          // final encrypter = enCrypt.Encrypter(enCrypt.AES(key));
          // final encrypted = encrypter.encrypt(psd, iv: iv);
          // final decrypted = encrypter.decrypt(encrypted, iv: iv);
          // print(decrypted);
          // print(encrypted.base64);
          prefs.setString('isSetPsd', 'true');
          prefs.setString('psd', psd);
          Navigator.of(context).pushReplacementNamed('home');
        } else {
          setState(() {
            _hasError = '两次密码不一致';
          });
        }
      },
      onHitPoint: () {
        setState(() {
          _hasError = '';
        });
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
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Text(
                    flag ? '再次绘制图案进行确认' : '绘制解锁图案',
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
                      _hasError,
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
            if (flag)
              TextButton(
                child: Text('重新绘制'),
                onPressed: () {
                  setState(() {
                    flag = false;
                    _hasError = '';
                  });
                },
              )
          ],
        ),
      ),
    );
  }
}
