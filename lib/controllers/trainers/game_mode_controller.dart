import 'package:camera/camera.dart';
import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/route/route.dart';
import 'package:robot/utils/ble_send_util.dart';
import 'package:robot/utils/navigator_util.dart';
import 'package:robot/views/tracking/game_mode_view.dart';

import '../../utils/global.dart';

class GameModeController extends StatefulWidget {
  const GameModeController({super.key});

  @override
  State<GameModeController> createState() => _GameModeControllerState();
}

class _GameModeControllerState extends State<GameModeController> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preLoadImage();
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.selectRecord = false;
  }

  preLoadImage() {
    // 预加载下个页面的的游戏数据显示的试图的背景图片 防止每次启动初次打开加载会闪屏的显现象 应该是图片过大影响的
    Future.delayed(Duration(milliseconds: 100), () {
      precacheImage(
        ExactAssetImage('images/gamemodel/计分栏蓝色底带红框.png'),
        context,
      );
      precacheImage(
        ExactAssetImage('images/gamemodel/single_bg.png'),
        context,
      );
      precacheImage(
        ExactAssetImage('images/gamemodel/battle_bg.png'),
        context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalWillPopScope(
        child: BaseViewController(
          child: Padding(
            padding: EdgeInsets.only(top: 32, bottom: 32, left: 16, right: 16),
            child: Column(
              children: [
                Expanded(
                  child: GameModeView(
                    modeID: 1,
                    play: () {
                      // Novice游戏模式页面
                      BLESendUtil.noviceShake();
                      NavigatorUtil.push(Routes.novice);
                    },
                  ),
                  flex: 1,
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: GameModeView(
                    modeID: 2,
                    containRecording: true,
                    play: () async {
                      BLESendUtil.juniorShake();
                      GameUtil gameUtil = GetIt.instance<GameUtil>();
                      if (gameUtil.selectRecord == true) {
                        List<CameraDescription> cameras =
                            await availableCameras();
                        NavigatorUtil.push(Routes.juniorrecord,
                            arguments: cameras[0]);
                      } else {
                        NavigatorUtil.push(Routes.junior);
                      }
                    },
                    recordSelect: (bool value) {
                      GameUtil gameUtil = GetIt.instance<GameUtil>();
                      gameUtil.selectRecord = value;
                    },
                  ),
                  flex: 1,
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: GameModeView(
                      modeID: 3,
                      play: () {
                        BLESendUtil.juniorShake();
                        NavigatorUtil.push(Routes.battle);
                      }),
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          // GameUtil gameUtil = GetIt.instance<GameUtil>();
          // gameUtil.pageDepth -= 1; // 页面深度减1
          // if (gameUtil.pageDepth < 0) {
          //   gameUtil.pageDepth = 0;
          // }
          return true;
        },
        shouldAddCallback: false);
  }
}
