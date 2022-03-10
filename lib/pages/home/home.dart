// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List merchantList = [];

  ///读取商户列表文件
  void loadLists() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final file = File(appDocPath + 'merchantList.json');
    if (await file.exists()) {
      final data = await file.readAsString();
      final merList = jsonDecode(data);
      setState(() {
        merchantList = merList;
      });
    }
  }

  @override
  void initState() {
    loadLists();
    super.initState();
  }

  Widget drawer = ListView(
    children: [
      ListTile(
        title: const Text('修改手势密码'),
        onTap: () {},
        dense: true,
        leading: const Icon(Icons.settings),
        minLeadingWidth: 20,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: SizedBox(
        child: Drawer(
          child: drawer,
          backgroundColor: Colors.white,
        ),
        width: 180,
      ),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.add,
              // color: Colors.blue,
              // size: 25,
            ),
            tooltip: '点击添加',
            offset: const Offset(10.0, 10.0),
            onSelected: (value) {
              if (value == 'sr') {
                Navigator.of(context).pushNamed(
                  "add_key",
                );
              }
              // else {
              //   Navigator.of(context).pushNamed(
              //     "qr_code_scan",
              //   );
              // }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  // child: Text("扫码"),
                  child: ListTile(
                    leading: Icon(
                      Icons.qr_code_scanner,
                      size: 20,
                    ),
                    title: Text(
                      '扫描二维码',
                      style: TextStyle(fontSize: 12),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.all(0),
                    minLeadingWidth: 16,
                  ),
                  value: "sm",
                  // padding: EdgeInsets.all(0),
                  height: 16,
                ),
                PopupMenuItem(
                  // child: Text("输入设置密钥"),
                  child: ListTile(
                    leading: Icon(
                      Icons.keyboard,
                      size: 20,
                    ),
                    dense: true,
                    title: Text(
                      '输入设置密钥',
                      style: TextStyle(fontSize: 12),
                    ),
                    contentPadding: EdgeInsets.all(0),
                    minLeadingWidth: 16,
                  ),
                  value: "sr",
                  // padding: EdgeInsets.all(0),
                  height: 16,
                ),
              ];
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: merchantList.length,
        itemBuilder: (BuildContext context, int index) {
          String name = merchantList[index]['name'];
          String no = merchantList[index]['no'];
          String key = merchantList[index]['key'];
          return SwipeActionCell(
              backgroundColor: Colors.white,
              key: ValueKey(no),
              trailingActions: [
                SwipeAction(
                  onTap: (CompletionHandler handler) async {
                    merchantList.removeAt(index);

                    ///获取本地列表,进行删除操作
                    Directory appDocDir =
                        await getApplicationDocumentsDirectory();
                    String appDocPath = appDocDir.path;
                    final file = File(appDocPath + 'merchantList.json');
                    if (await file.exists()) {
                      file.delete();
                      file.writeAsString(jsonEncode(merchantList));
                    }
                    await handler(true);
                  },
                  nestedAction: SwipeNestedAction(title: "确认删除"),
                  title: "删除",
                  color: Colors.red,
                )
              ],
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("add_code", arguments: key);
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Color.fromARGB(255, 214, 211, 211),
                    width: 0.8,
                  ))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            no,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            name,
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                ),
              ));
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
