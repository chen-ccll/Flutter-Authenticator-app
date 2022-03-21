// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_final_fields, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ItemModel {
  String title;
  IconData icon;
  String path;
  ItemModel(this.title, this.icon, this.path);
}

class _MyHomePageState extends State<MyHomePage> {
  CustomPopupMenuController _controller = CustomPopupMenuController();
  late List<ItemModel> menuItems;
  List merchantList = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  ///拖动组件的方法
  void onReorder(int oldIndex, int newIndex) {
    //第一个参数是旧的数据索引，第二个参数是拖动到位置的索引
    setState(() {
      //如果向下拖动，拖动到新位置的索引需要减一
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      var item = merchantList.removeAt(oldIndex);
      merchantList.insert(newIndex, item);
      onSaveList(merchantList);
      setState(() {
        merchantList = merchantList;
      });
    });
  }

  ///保存本地列表
  void onSaveList(List merchantList) async {
    try {
      ///获取本地列表,重新保存列表数据
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final file = File(appDocPath + 'merchantList.json');
      if (await file.exists()) {
        file.delete();
        file.writeAsString(jsonEncode(merchantList));
      }
    } catch (e) {
      print(e);
    }
  }

  Widget drawer(context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('修改手势密码'),
          onTap: () {
            Navigator.of(context).pushNamed('edit_psd');
          },
          dense: true,
          leading: const Icon(
            Icons.settings,
            color: Colors.blue,
          ),
          minLeadingWidth: 20,
        ),
      ],
    );
  }

  Widget menuItem(e) {
    String name = e['name'];
    String no = e['no'];
    String key = e['key'];
    return SwipeActionCell(
        backgroundColor: Colors.white,
        key: ValueKey(no),
        trailingActions: [
          SwipeAction(
            onTap: (CompletionHandler handler) async {
              await handler(true);
              int a = merchantList.indexWhere((item) => item['no'] == e['no']);
              merchantList.removeAt(a);
              onSaveList(merchantList);
              setState(() {
                merchantList = merchantList;
              });
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
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Color.fromARGB(255, 168, 166, 166),
              width: 0.8,
            ))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 20,
                child: Text(
                  no,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                child: Text(
                  name,
                  // style: TextStyle(fontSize: 16),
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    menuItems = [
      ItemModel('扫二维码', Icons.qr_code_scanner, 'qr_code_scan'),
      ItemModel('输入密钥', Icons.create, 'add_key'),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: SizedBox(
        child: Drawer(
          child: drawer(context),
          backgroundColor: Colors.white,
        ),
        // width: 180,
        width: MediaQuery.of(context).size.width / 2,
      ),
      appBar: AppBar(
        // shadowColor: Colors.white,
        actions: [
          CustomPopupMenu(
            child: Container(
              child: Icon(Icons.add, color: Colors.white),
              padding: EdgeInsets.all(20),
            ),
            menuBuilder: () => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: const Color(0xFF4C4C4C),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menuItems
                        .map(
                          (item) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              _controller.hideMenu();
                              if (item.path == 'add_key') {
                                Navigator.of(context).pushNamed('add_key');
                              } else {
                                final SharedPreferences prefs = await _prefs;
                                prefs.setString('isSetPsd', 'false');
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.white,
                                width: 0.3,
                              ))),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    item.icon,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      // padding:
                                      //     EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        item.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            pressType: PressType.singleClick,
            verticalMargin: -10,
            controller: _controller,
          ),
        ],
      ),

      ///可拖动列表组件
      body: ReorderableListView(
        children: merchantList.map((item) => menuItem(item)).toList(),
        shrinkWrap: true,
        onReorder: onReorder,
        // physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10),
      ),
    );
  }
}
