import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// 用户信息模型
class UserModel extends ChangeNotifier {
  String _userName = 'Default'; // 同户名
  String _avatar = ''; // 头像
  String _brith = '-'; // 用户生日
  String _team = 'Default'; // team生日
  // get方法
  String get userName => _userName;
  String get avatar => _avatar;
  String get brith => _brith;
  String get team => _team;

  // set方法
  set userName(String name) {
    _userName = name;
    notifyListeners();
  }

  set avatar(String avatar) {
    _avatar = avatar;
    notifyListeners();
  }

  set brith(String brith) {
    _brith = brith;
    notifyListeners();
  }

  set team(String team) {
    _team = team;
    notifyListeners();
  }


}

// 创建一个全局的Provider
class UserProvider extends StatelessWidget {
  final Widget child;

  UserProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: child,
    );
  }

  static UserModel of(BuildContext context) {
    return Provider.of<UserModel>(context, listen: false);
  }
}