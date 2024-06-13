import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/utils/ble_send_util.dart';
import 'package:robot/utils/count_down_75_timer.dart';
import 'package:robot/utils/data_base.dart';
import 'package:robot/utils/string_util.dart';
import 'package:robot/views/tracking/speed_view.dart';
import 'package:robot/views/tracking/stop_watch_view.dart';
import '../../utils/ble_data_service.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';
import '../../utils/notification_bloc.dart';
import 'dart:math' as math;
class BattleController extends StatefulWidget {
  const BattleController({super.key});

  @override
  State<BattleController> createState() => _BattleControllerState();
}

class _BattleControllerState extends State<BattleController> {
  late Countdown75Timer _countdownTimer;
  late StreamSubscription subscription;
  Timer? timer;
  Timer? redTimer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) async{
      if (event == kJuniorGameEnd){
        if (mounted) {
          resetTimer();
          resetRedTimer();
          await BLESendUtil.blueLightBlink();
          await BLESendUtil.openAllBlueLight();
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
            _redScore = '0';
            setState(() {

            });
          }
          if (begainGame) {
            // 先取消自动刷新的定时器
            int targetNumber = BluetoothManager().gameData.targetNumber;

            // print('BluetoothManager().battleTargetNumbers= ${BluetoothManager().battleTargetNumbers}');
            // print('targetNumber=${targetNumber}');
            // print('BluetoothManager().battleBlueIndex=${BluetoothManager().battleBlueIndex}');
            // print('BluetoothManager().battleRedIndex=${BluetoothManager().battleRedIndex}');

            if (targetNumber ==
                BluetoothManager().battleBlueIndex) {
              resetTimer();
              // 击中了蓝灯
              _score = (kTargetAndScoreMap[targetNumber]! + int.parse(_score))
                  .toString();
              setState(() {});
              // 然后再随机点亮一个蓝灯
             await BLESendUtil.battleControlBlueLight();
              autoRefreshControl();
            } else if (targetNumber ==
                BluetoothManager().battleRedIndex) {
              // 先取消自动刷新的定时器
              resetRedTimer();
              // 击中了红灯
              print('击中红灯targetNumber=${targetNumber}');
              _redScore = (kTargetAndScoreMap[targetNumber]! + int.parse(_redScore))
                  .toString();
              setState(() {});
              // 然后再随机点亮一个红灯
             await BLESendUtil.battleControlRedLight();
              autoRedRefreshControl();
            }
          }
        }
      } else {}
    };
  }

  autoRefreshControl() {
    resetTimer();
    timer = Timer.periodic(Duration(milliseconds: kAutoRefreshDuration), (Timer t) async{
     await  BLESendUtil.battleControlBlueLight();
    });
  }

  autoRedRefreshControl() {
    resetRedTimer();
    redTimer = Timer.periodic(Duration(milliseconds: kAutoRefreshDuration), (Timer t) async{
      await BLESendUtil.battleControlRedLight();
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

  resetRedTimer(){
    if (redTimer != null) {
      if (redTimer!.isActive) {
        redTimer!.cancel();
        redTimer = null;
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
          _score = _secondsRemaining.toString();
          _secondsRemaining--; // 每秒递减
        });
      } else {
        timer.cancel(); // 倒计时结束，取消定时器
        _score = 'GO';
        setState(() {});
        begainGame = true;
        // 正式开始游戏
        // 蓝色
        await BLESendUtil.battleControlBlueLight();
        autoRefreshControl();
        // 红色
        await  BLESendUtil.battleControlRedLight();
        autoRedRefreshControl();
        // 正式开始游戏
        _countdownTimer.start();
      }
    });
  }

  int _secondsRemaining = 3; // 倒计时时间
  String _score = '0'; // 蓝方得分
  String _redScore = '0'; // 红方得分
  bool firsthit = false; // 首次击中
  bool begainGame = false;
  @override
  Widget build(BuildContext context) {
    final _width = Constants.screenWidth(context) - 64;
    final _height = Constants.screenHeight(context) - Constants.tabBarHeight - Constants.navigationBarHeight - 32 - 16  - 60 - 16 - 80 - 32;
    return BaseViewController(
        paused: () {
          timer?.cancel();
          redTimer?.cancel();
          _countdownTimer.stop();
          _countdownTimer.dispose();
          subscription.cancel();
          BLESendUtil.blueLightBlink();
          BLESendUtil.appOffLine();
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
                          image: AssetImage('images/gamemodel/battle_bg.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          child: Constants.boldWhiteTextWidget(_score, 80,height: 1.0),
                          // color: Colors.green,
                        ),
                        left: 0,
                        right: _width/2.0,
                        top: _height/2.0 - 100,
                     //   bottom: _height/2.0 - 80,
                      ),
                      Positioned(
                        child: Container(
                          // color: Colors.green,
                          child: Center(child: Constants.boldWhiteTextWidget(_redScore, 80,height: 1.0),),
                          // color: Colors.green,
                        ),
                        left: _width/2.0,
                        right: 0,
                        bottom: _height/2.0 - 100,
                        //   bottom: _height/2.0 - 80,
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
              // SpeedView(speed: '0'),
              SizedBox(
                height: 112,
              ),
            ],
          ),
        ));  }
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
    redTimer?.cancel();
    _countdownTimer.stop();
    _countdownTimer.dispose();
    subscription.cancel();
    BLESendUtil.blueLightBlink();
    //  WidgetsBinding.instance.removeObserver(this);
  }
}
