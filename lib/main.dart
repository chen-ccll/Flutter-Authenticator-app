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
  ///获取验证码

  static String addCode = 'add_code';

  ///首页
  static String home = 'home';

  ///添加用户key
  static String addKey = 'add_key';

  ///二维码扫描
  static String qrCodeScan = 'qr_code_scan';

  ///设置手势密码
  static String setPsd = 'set_psd';

  ///手势解锁
  static String gestureUnlock = 'gesture_unlock';

  ///修改手势密码
  static String editPsd = 'edit_psd';

  ///路由配置
  static Map<String, WidgetBuilder> routerConfig = {
    addCode: (context) => const AddCode(),
    home: (context) => const MyHomePage(title: ''),
    addKey: (context) => const AddKey(),
    qrCodeScan: (context) => const QRCodeScan(),
    setPsd: (context) => const SetPsd(),
    gestureUnlock: (context) => const GestureUnLock(),
    editPsd: (context) => const EditPsd(),
  };

  ///路由拦截器
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

      ///初始加载路由界面
      initialRoute: RouterConfig.gestureUnlock,
    );
  }
}
