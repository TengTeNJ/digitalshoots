import 'package:flutter/material.dart';

class NavigatorUtil {
  static late BuildContext utilContext;

  // 设置NavigatorState，通常在应用启动时调用
  static void init(BuildContext context) {
    utilContext = context;
  }

  // 跳转到新页面（push）
  static push(String routeName,{Object arguments = const Object()}) {
    return Navigator.pushNamed(NavigatorUtil.utilContext, routeName,arguments: arguments);
  }

  //  出栈（pop）
  static pop() {
    return Navigator.of(NavigatorUtil.utilContext).pop();
  }

  static popAndThenPush(String routeName,{Object arguments = const Object()}){
    return Navigator.of(NavigatorUtil.utilContext).popAndPushNamed(routeName,arguments: arguments);
  }

  //  模态效果
  static present(Widget widget) {
    showModalBottomSheet(
      isScrollControlled: true, // 设置为false话 弹窗的高度就会固定
      context: NavigatorUtil.utilContext,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          child: widget,
        );
      },
    );
  }

  // 跳转到根试图
  static popToRoot(){
    Navigator.of(NavigatorUtil.utilContext).popUntil((route) => route.isFirst);
  }
}
