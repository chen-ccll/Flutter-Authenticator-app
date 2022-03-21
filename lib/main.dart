import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/pages/home/home.dart';
import 'package:flutter_application_1/pages/add_code/add_code.dart';
import 'package:flutter_application_1/pages/add_key/add_key.dart';
import 'package:flutter_application_1/pages/qr_code_scan/qr_code_scan.dart';
import 'package:flutter_application_1/pages/set_psd/set_psd.dart';
import 'package:flutter_application_1/pages/gesture_unlock/gesture_unlock.dart';
import 'package:flutter_application_1/pages/edit_psd/edit_psd.dart';

import 'package:flutter_application_1/global.dart';

void main() {
  Global.init().then((e) => runApp(MyApp()));
}

class RouterConfig {
  static String addCode = 'add_code';
  static String home = 'home';
  static String addKey = 'add_key';
  static String qrCodeScan = 'qr_code_scan';
  static String setPsd = 'set_psd';
  static String gestureUnlock = 'gesture_unlock';
  static String editPsd = 'edit_psd';
  static Map<String, WidgetBuilder> routerConfig = {
    addCode: (context) => const AddCode(),
    home: (context) => const MyHomePage(title: ''),
    addKey: (context) => const AddKey(),
    qrCodeScan: (context) => const QRCodeScan(),
    setPsd: (context) => const SetPsd(),
    gestureUnlock: (context) => const GestureUnLock(),
    editPsd: (context) => const EditPsd(),
  };

  static Route onGenerateRoute<T extends Object>(RouteSettings settings) {
    return CupertinoPageRoute<T>(
      settings: settings,
      builder: (context) {
        String? name = settings.name;
        final _isSetPsd = Global.isSetPsd;
        Widget widget = routerConfig[name]!(context);
        if (_isSetPsd == null || _isSetPsd == 'false') {
          return routerConfig[setPsd]!(context);
        }
        return widget;
      },
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey navigationKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: RouterConfig.onGenerateRoute,
      initialRoute: RouterConfig.gestureUnlock,
    );
  }
}
