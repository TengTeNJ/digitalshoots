import 'package:camera/camera.dart';
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
  Widget build(BuildContext context) {
    return BaseViewController(
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
                    List<CameraDescription> cameras = await availableCameras();
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
    );
  }
}
