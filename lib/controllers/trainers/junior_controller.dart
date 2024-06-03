import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/utils/ble_send_util.dart';
import 'package:robot/utils/count_down_75_timer.dart';
import 'package:robot/utils/data_base.dart';
import 'package:robot/views/tracking/speed_view.dart';
import 'package:robot/views/tracking/stop_watch_view.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/ble_data_service.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/count_down_timer.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';
import '../../utils/notification_bloc.dart';

class JuniorController extends StatefulWidget {
  const JuniorController({super.key});

  @override
  State<JuniorController> createState() => _JuniorControllerState();
}

class _JuniorControllerState extends State<JuniorController> {
  late Countdown75Timer _countdownTimer;
  late StreamSubscription subscription;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    subscription = EventBus().stream.listen((event) async{
      if (event == kJuniorGameEnd){
        if (mounted) {
          resetTimer();
          await BLESendUtil.openAllBlueLight();
          // 先保存数据
          Gamemodel model =
              Gamemodel.modelFromJson({'score': _score.toString()});
          await DatabaseHelper().insertData(kDataBaseTableName, model);
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
          if (_score == 'GO') {
            _score = '0';
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
        BLESendUtil.juniorControlLight();
        autoRefreshControl();
        // 正式开始游戏
        _countdownTimer.start();
      }
    });
  }

  int _secondsRemaining = 3; // 倒计时时间
  String _score = '0'; // 得分
  bool firsthit = false; // 首次击中
  bool begainGame = false;

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
                          image: AssetImage('images/gamemodel/single_bg.png'),
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
              SpeedView(speed: '0'),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ));
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _countdownTimer.stop();
    _countdownTimer.dispose();
    subscription.cancel();
    //  WidgetsBinding.instance.removeObserver(this);
  }
}
