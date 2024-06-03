import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:camera/camera.dart';
import 'package:robot/model/user_info.dart';
import 'package:robot/utils/color.dart';
import 'package:device_screen_recorder/device_screen_recorder.dart';
import 'package:robot/utils/string_util.dart';
import 'package:robot/utils/toast.dart';

import '../../model/game_model.dart';
import '../../utils/ble_data_service.dart';
import '../../utils/ble_send_util.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/count_down_75_timer.dart';
import '../../utils/data_base.dart';
import '../../utils/global.dart';
import '../../utils/notification_bloc.dart';
class JuniorRecordController extends StatefulWidget {
  CameraDescription camera;

  JuniorRecordController({required this.camera});

  @override
  State<JuniorRecordController> createState() => _JuniorRecordControllerState();
}

class _JuniorRecordControllerState extends State<JuniorRecordController> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late Countdown75Timer _countdownTimer;
  late StreamSubscription subscription;
  Timer? timer;

  int _secondsRemaining = 3; // 倒计时时间
  String _score = '0'; // 得分
  String _speed = '0' ;// 速度
  String _countDownString = '00:00';
  bool firsthit = false; // 首次击中
  bool begainGame = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initCamera();
   //  DeviceScreenRecorder.startRecordScreen(name: 'example');
    subscription = EventBus().stream.listen((event) async{
      if (event == kJuniorGameEnd){
        if (mounted) {
          resetTimer();
          TTToast.showLoading();
          final _path =   await  DeviceScreenRecorder.stopRecordScreen();
          print('视频保存路径:${_path}');
          await BLESendUtil.openAllBlueLight();
          // DeviceScreenRecorder
          // 先保存数据
          Gamemodel model =
          Gamemodel.modelFromJson({'score': _score.toString(),'path':_path});
          await DatabaseHelper().insertData(kDataBaseTableName, model);
          TTToast.hideLoading();
          // 初始化状态
          initStatu();
        }
      }
    });
    // 初始化秒表倒计时
    _countdownTimer = Countdown75Timer(
      onTick: () {
        setState(() {
          // 调用setState来触发UI更新
        });
      },
    );
    // 标记在游戏页面
    GameUtil gameUtil = GetIt.instance<GameUtil>();
    gameUtil.nowISGamePage = true;
    // 进入页面打开所有蓝灯
    BLESendUtil.openAllBlueLight();
    // 蓝牙数据监听
    BluetoothManager().dataChange = (BLEDataType type) async {
      if (type == BLEDataType.targetIn) {
        if (!firsthit) {
          firsthit = true;
          // 熄灭所有的灯光
          BLESendUtil.closeAllLight();
          // 3 2 1 Go 然后开开始游戏
          _startCountdown();
        } else {
          if (_countDownString == 'GO') {
            _countDownString = '00:00';
          }
          if (begainGame) {
            // 先取消自动刷新的定时器
            timer?.cancel();
            int targetNumber = BluetoothManager().gameData.targetNumber;
            if (targetNumber ==
                kJuniorBluetargets[BluetoothManager().juniorBlueIndex]) {
              // 击中了蓝灯
              _score = (kTargetAndScoreMap[targetNumber]! + int.parse(_score))
                  .toString();
              setState(() {});
              // 然后再随机点亮红和蓝灯各一个
              BLESendUtil.juniorControlLight();
              autoRefreshControl();
            } else if (targetNumber ==
                kJuniorRedtargets[BluetoothManager().juniorRedIndex]) {
              // 先取消自动刷新的定时器
              timer?.cancel();
              // 击中了红灯
              _score = (kTargetAndScoreMap[targetNumber]! + int.parse(_score))
                  .toString();
              setState(() {});
              // 然后再随机点亮红和蓝灯各一个
              BLESendUtil.juniorControlLight();
              autoRefreshControl();
            }
          }
        }
      } else {}
    };
  }

  autoRefreshControl() {
    resetTimer();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      print('自动刷新执行------');
      BLESendUtil.juniorControlLight();
    });
  }

  /*重置定时器*/
  resetTimer(){
    if (timer != null) {
      if (timer!.isActive) {
        timer!.cancel();
        timer = null;
      }
    }
  }

  /*初始化状态*/
  void initStatu() {
    _secondsRemaining = 3;
    firsthit = false;
    begainGame = false;
  }

  void _startCountdown() {
    setState(() {
      BLESendUtil.preGame(_secondsRemaining);
      _score = _secondsRemaining.toString();
      _secondsRemaining--; // 每秒递减
    });
    Timer.periodic(Duration(seconds: 1), (timer) async{
      if (_secondsRemaining > 0) {
        setState(() {
          BLESendUtil.preGame(_secondsRemaining);
          _countDownString = _secondsRemaining.toString();
          _secondsRemaining--; // 每秒递减
        });
      } else {
        timer.cancel(); // 倒计时结束，取消定时器
        _countDownString = 'GO';
        setState(() {});
        // 开始录屏
       await DeviceScreenRecorder.startRecordScreen(name: 'example');
        begainGame = true;
        BLESendUtil.juniorControlLight();
        autoRefreshControl();
        // 正式开始游戏
        _countdownTimer.start();
      }
    });
  }
  /*初始化相机*/
  initCamera() {
    // 初始化相机相关
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BaseViewController(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 32),
        child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              return SizedBox(
                child: ClipRRect(
                  child: CameraPreview(
                    _controller,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Constants.boldWhiteItalicTextWidget(
                                'DIGITAL SHOTS', 20),
                            Column(
                              children: [
                                Image(
                                  image: AssetImage('images/header.png'),
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Consumer<UserModel>(
                                    builder: (context, userModel, child) {
                                  return Constants.boldWhiteItalicTextWidget(
                                      userModel.userName, 18);
                                })
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              height: 110,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: hexStringToOpacityColor('#F8850B', 0.6)
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Constants.regularWhiteTextWidget('SCORE', 16),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Constants.digiRegularWhiteTextWidget(_score.padLeft(3,'0'), 40),
                                ],
                              ),


                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              height: 110,
                              width: Constants.screenWidth(context) - 160 - 32 -8 - 24,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: hexStringToOpacityColor('#F8850B', 0.6)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Constants.regularWhiteTextWidget('TIME LEFT', 16),
                                  Constants.digiRegularWhiteTextWidget( begainGame == false ? _countDownString :   _countdownTimer.formattedTime, 60),
                                  Constants.regularWhiteTextWidget('JUNIOR', 16),
                                ],
                              ),

                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              height: 110,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: hexStringToOpacityColor('#F8850B', 0.6)
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Constants.regularWhiteTextWidget('SPEED', 16),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Constants.digiRegularWhiteTextWidget(_speed.padLeft(3,'0'), 40),
                                ],
                              ),


                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }),
      ),
    );
  }
}
