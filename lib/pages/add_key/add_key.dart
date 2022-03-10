// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AddKey extends StatefulWidget {
  const AddKey({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddKeyState();
  }
}

class _AddKeyState extends State<AddKey> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _unoController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusScopeNode? focusScopeNode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('输入用户密钥')),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, //设置globalKey，用于后面获取FormState
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
                  focusNode: focusNode1, //关联focusNode1
                  // autofocus: true,
                  keyboardType: TextInputType.text,
                  controller: _unameController,
                  decoration: const InputDecoration(
                    labelText: "商户名",
                    filled: true,
                    // labelStyle: TextStyle(fontSize: 14),
                    // hintText: "商户号",
                    // icon: Icon(Icons.person),
                  ),
                  // 校验用户名
                  validator: (v) {
                    return v!.trim().isEmpty ? "商户名不能为空" : null;
                  },
                  // onFieldSubmitted: (v) {
                  //   focusScopeNode ??= FocusScope.of(context);
                  //   focusScopeNode?.requestFocus(focusNode2);
                  // },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  focusNode: focusNode2, //关联focusNode1
                  // autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: _unoController,
                  decoration: const InputDecoration(
                    labelText: "商户号",
                    filled: true,
                    // labelStyle: TextStyle(fontSize: 14),
                    // hintText: "商户号",
                    // icon: Icon(Icons.pin),
                  ),
                  // 校验用户名
                  validator: (v) {
                    // print(v);
                    return v!.trim().isNotEmpty ? null : "商户号不能为空";
                  },
                  // onFieldSubmitted: (v) {
                  //   focusScopeNode ??= FocusScope.of(context);
                  //   focusScopeNode?.requestFocus(focusNode3);
                  // },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  focusNode: focusNode3, //关联focusNode1
                  controller: _pwdController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "密钥",
                    filled: true,
                    // hintText: "密钥",
                    // icon: Icon(Icons.key),
                  ),
                  //校验密码
                  validator: (v) {
                    return v!.trim().isNotEmpty ? null : "密钥不能为空";
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // 按钮
                SizedBox(
                  // margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: const Text("添加"),
                        onPressed: () async {
                          if ((_formKey.currentState as FormState).validate()) {
                            //验证通过提交数据
                            var obj = {};
                            obj['name'] = _unameController.text;
                            obj['no'] = _unoController.text;
                            obj['key'] = _pwdController.text;
                            List merchantList = [];
                            merchantList.add(obj);
                            Directory appDocDir =
                                await getApplicationDocumentsDirectory();
                            String appDocPath = appDocDir.path;
                            final file = File(appDocPath + 'merchantList.json');
                            if (await file.exists()) {
                              final data = await file.readAsString();
                              final List merList = jsonDecode(data);
                              merList.add(obj);
                              file.writeAsString(jsonEncode(merList));
                            } else {
                              file.writeAsString(jsonEncode(merchantList));
                            }
                            Navigator.of(context).pushReplacementNamed("home");
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
