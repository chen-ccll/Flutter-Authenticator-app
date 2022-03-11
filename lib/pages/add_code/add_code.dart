// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:otp/otp.dart';
import 'package:base32/base32.dart';
import 'dart:math';

class AddCode extends StatefulWidget {
  const AddCode({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddCodeState();
  }
}

class _AddCodeState extends State<AddCode> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  ///验证码显示
  bool flag = false;

  ///6位的验证码
  String code = '';
  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///拿到商户的密钥
    var args = ModalRoute.of(context)?.settings.arguments as String;
    const focusedBorderColor = Color.fromARGB(255, 17, 136, 206);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromARGB(102, 24, 109, 189);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "请输入6位随机码",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              if (!flag)
                Pinput(
                  autofocus: true,
                  controller: pinController,
                  focusNode: focusNode,
                  defaultPinTheme: defaultPinTheme,
                  length: 6,
                  validator: (s) {
                    if (s.toString().length < 6) {
                      return '请输入6位随机码';
                    }
                    Random random = Random.secure();

                    ///取0-100之间的随机整数
                    int _randomInt = random.nextInt(100);

                    ///加上用户输入的随机数生成base32编码
                    final _base32Code = base32.encodeString(args + s!);

                    ///最后输出6位的验证码
                    final _code =
                        OTP.generateHOTPCodeString(_base32Code, _randomInt);
                    setState(() {
                      code = _code;
                      flag = true;
                    });
                    return null;
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              const SizedBox(
                height: 100,
              ),
              if (flag)
                const Text(
                  '验证码:',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              if (flag)
                Text(
                  code,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              if (flag)
                ElevatedButton(
                  child: const Text('重新输入'),
                  onPressed: () {
                    pinController.clear();
                    setState(() {
                      flag = false;
                    });
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
