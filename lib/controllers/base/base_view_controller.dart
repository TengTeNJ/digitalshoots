import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/utils/ble_send_util.dart';
import 'package:robot/utils/navigator_util.dart';
import 'package:robot/widges/base/customAppBar.dart';
import 'package:robot/widges/base/custom_tab_bar.dart';

import '../../utils/global.dart';

class BaseViewController extends StatefulWidget {
  Widget? child;
  bool showBottomBar;
  bool resizeToAvoidBottomInset;
  Function? paused;
  Function? onWillPop;

  BaseViewController(
      {this.child,
      this.resizeToAvoidBottomInset = false,
      this.showBottomBar = true,
      this.paused,
      this.onWillPop});

  @override
  State<BaseViewController> createState() => _BaseViewControllerState();
}

class _BaseViewControllerState extends State<BaseViewController>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 监听生命周期
    WidgetsBinding.instance.addObserver(this);
    print('BaseViewController initState');
  }

  /*生命周期函数*/
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      // 进入到后台 如果在游戏界面 直接退出游戏页面 并且退出app模式
      if (widget.paused != null) {
        widget.paused!();
      }
      print('App entered background');
    } else if (state == AppLifecycleState.resumed) {
      GameUtil gameUtil = GetIt.instance<GameUtil>();
      print('App returned to foreground');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.showBottomBar
        ? Scaffold(
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            appBar: CustomAppBar(),
            bottomNavigationBar: CustomBottomNavigationBar(),
            body: Container(
              width: Constants.screenWidth(context),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background.png'), // 替换为你的图片路径
                    fit: BoxFit.cover, // 根据需要调整图片的适应方式
                  ),
                ),
                child: widget.child,
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            appBar: CustomAppBar(),
            body: Container(
              width: Constants.screenWidth(context),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background.png'), // 替换为你的图片路径
                    fit: BoxFit.cover, // 根据需要调整图片的适应方式
                  ),
                ),
                child: widget.child,
              ),
            ),
          );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print('BaseViewController dispose');
  }
}
