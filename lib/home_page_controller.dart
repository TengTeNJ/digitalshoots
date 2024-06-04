import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/controllers/my/my_account_controller.dart';
import 'package:robot/controllers/status/my_status_controller.dart';
import 'package:robot/controllers/tracking/tracking_controller.dart';
import 'package:robot/controllers/trainers/trainers_home_conroller.dart';
import 'package:robot/utils/blue_tooth_manager.dart';
import 'package:robot/utils/global.dart';
import 'package:robot/utils/local_data_util.dart';
import 'package:robot/utils/navigator_util.dart';
import 'package:robot/utils/notification_bloc.dart';
import 'package:robot/widges/base/customAppBar.dart';
import 'package:robot/widges/base/custom_tab_bar.dart';

class HomePageController extends StatefulWidget {
  const HomePageController({super.key});

  @override
  State<HomePageController> createState() => _HomePageControllerState();
}

class _HomePageControllerState extends State<HomePageController> {
  late StreamSubscription subscription;
  int _currentPage = 0;
  List<Widget>_controllers = [TrainersHomeController(),TrackingController(),MyStatusController(),MyAccountController()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 确认有没有需要删除的视频
    LocalDataUtil.getDeletedVideoPath();
    // 开市搜索蓝牙设备
    BluetoothManager().startScan();
    subscription = EventBus().stream.listen((event) {
      if (event == kTabBarPageChange) {
        GameUtil gameUtil = GetIt.instance<GameUtil>();
          if (mounted) {
            setState(() {
              if(_currentPage != gameUtil.currentPage && gameUtil.pageDepth >0){
                NavigatorUtil.popToRoot();
                EventBus().sendEvent(kTabBarPageChangeToRoot);
              }
              _currentPage = gameUtil.currentPage;
            });
          }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    NavigatorUtil.init(context);
    return Scaffold(
    body: _controllers[_currentPage],
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  @override void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
    print('HomePageController dispose');
  }
}
