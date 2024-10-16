import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/utils/ble_send_util.dart';
import 'package:robot/views/tracking/speed_view.dart';
import 'package:robot/views/tracking/stop_watch_view.dart';

import '../../utils/ble_data_service.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/count_down_timer.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class NoviceController extends StatefulWidget {
  const NoviceController({super.key});

  @override
  State<NoviceController> createState() => _NoviceControllerState();
}

class _NoviceControllerState extends State<NoviceController>
    with WidgetsBindingObserver {
  late CountdownTimer _countdownTimer;

  List<int> doneLights = []; // 已经关闭的灯
  int _secondsRemaining = 3; // 倒计时时间
  String _score = '0'; // 得分
  String _speed = '0'; // 速度
  bool firsthit = false; // 首次击中
  bool begainGame = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    // 初始化秒表倒计时
    _countdownTimer = CountdownTimer(
      onTick: () {
        print('_countdownTimer.formattedTime=${_countdownTimer.formattedTime}');
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
          if (begainGame) {
            int targetNumber = BluetoothManager().gameData.targetNumber;
            if (!doneLights.contains(targetNumber - 1)) {
              doneLights.add(targetNumber - 1);
              // 更新得分
              _score = doneLights.length.toString();
              //  每次击中 则关闭此灯
             BLESendUtil.closeBlueLights(doneLights);
             // BLESendUtil.closeAllBlueLight(doneights);

              // 打开紫灯
              print('击中的灯的索引${targetNumber}');
              print('已经关闭的灯的索引${doneLights}');
              Future.delayed(Duration(milliseconds: 10),(){
                BLESendUtil.openPurpleLights(targetNumber);
              });

              // 关闭紫灯
              Future.delayed(Duration(milliseconds: 500),(){
                BLESendUtil.closePurpleLights(targetNumber);
              });

              setState(() {});
              // 6个全部击中 则一轮游戏结束
              if (doneLights.length == 6) {
                // 一轮游戏结束
                _countdownTimer.stop();
                await BLESendUtil.blueLightBlink();
                await BLESendUtil.openAllBlueLight();
                initStatu();
              }
            }
          }
        }
      } else if (type == BLEDataType.speed) {
        print('novice_speed123');
        // 速度
        if (begainGame) {
          print('novice_speed456${_speed}');
          setState(() {
            _speed = BluetoothManager().gameData.speed.toString();
          });
        }
      }
    };
  }

  /*初始化状态*/
  void initStatu() {
    doneLights.clear();
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
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          BLESendUtil.preGame(_secondsRemaining);
          _score = _secondsRemaining.toString();
          _secondsRemaining--; // 每秒递减
        });
      } else {
        timer.cancel(); // 倒计时结束，取消定时器
        _score = 'GO';
        setState(() {});
        begainGame = true;
        BLESendUtil.openAllBlueLight();
        // 正式开始游戏
        _countdownTimer.start();
      }
    });
  }

  /*生命周期函数*/
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // TODO: implement didChangeAppLifecycleState
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.paused) {
  //     GameUtil gameUtil = GetIt.instance<GameUtil>();
  //     // 进入到后台 如果在游戏界面 直接退出游戏页面 并且退出app模式
  //     BLESendUtil.appOffLine();
  //     BLESendUtil.blueLightBlink();
  //     NavigatorUtil.popToRoot();
  //     print('App entered background');
  //   } else if (state == AppLifecycleState.resumed) {
  //     GameUtil gameUtil = GetIt.instance<GameUtil>();
  //     print('App returned to foreground');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BaseViewController(
        paused: () {
          BLESendUtil.appOffLine();
          BLESendUtil.blueLightBlink();
          NavigatorUtil.popToRoot();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 32, right: 32),
          child: Column(
            children: [
              SizedBox(
                height: 32,
              ),
              Constants.regularBaseTextWidget('GAME TIME', 16),
              StopWatchView(
                formaterText: _countdownTimer.formattedTime,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/gamemodel/计分栏蓝色底带红框.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          child: Center(
                            child: Constants.digiRegularWhiteTextWidget(
                                _score == 'GO' ? 'GO' : _score.padLeft(3, '0'),
                                160,
                                textAlign: TextAlign.center),
                          ),
                        ),
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                      ),
                      Positioned(
                        child: Constants.boldWhiteTextWidget('SCORE', 16,
                            textAlign: TextAlign.end),
                        left: 0,
                        right: 32,
                        bottom: 32,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
             // SpeedView(speed: _speed.padLeft(1, '100')),
              SpeedView(speed: _speed),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _countdownTimer.stop();
    _countdownTimer.dispose();
    BLESendUtil.blueLightBlink();
    print('novice 界面退出');
    //  WidgetsBinding.instance.removeObserver(this);
  }
}
