
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/controllers/base/video_play_controller.dart';
import 'package:robot/controllers/trainers/battle_controller.dart';
import 'package:robot/controllers/trainers/ble_list_controller.dart';
import 'package:robot/controllers/trainers/game_mode_controller.dart';
import 'package:robot/controllers/trainers/junior_controller.dart';
import 'package:robot/controllers/trainers/junior_record_controller.dart';
import 'package:robot/controllers/trainers/novice_controller.dart';

import '../utils/global.dart';



class Routes {
  static const String blelist = 'bleList'; // 主页
  static const String gamemodel = 'gameMode'; // 游戏模式页面
  static const String novice = 'novice'; // novice游戏模式页面
  static const String junior = 'junior'; // junior游戏模式页面
  static const String battle = 'battle'; // battle游戏模式页面
  static const String juniorrecord = 'juniorRecord'; // junior游戏模式 选择录屏
  static const String videoplay = 'videoplay'; // 视频播放页面

  //GameFinishController VideoPlayController
  static RouteFactory onGenerateRoute = (settings) {
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.pageDepth += 1; // 页面深度加1
    switch (settings.name) {
      case blelist:
        return MaterialPageRoute(builder: (_) => BLEListController());
      case gamemodel:
        return MaterialPageRoute(builder: (_) => GameModeController());
      case novice:
        return MaterialPageRoute(builder: (_) => NoviceController());
      case junior:
        return MaterialPageRoute(builder: (_) => JuniorController());
      case battle:
        return MaterialPageRoute(builder: (_) => BattleController());
      case juniorrecord:
        final  CameraDescription camera = settings.arguments as CameraDescription;
        return MaterialPageRoute(builder: (_) => JuniorRecordController(camera: camera,));
      case videoplay:
        final  String videopath = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => VideoPlayController(videopath: videopath,));
      default:
        return _errorRoute();
    }
  };

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}