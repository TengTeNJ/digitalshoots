import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameData  extends ChangeNotifier{
  bool _powerOn = false; // 开机状态
  int _currentTarget = 0; // 当前响应标靶
  int _score = 0; // 得分
  int _speed = 0; // 速度
  bool _gameStart = false; // 游戏状态
  int _powerValue = 100; // 电量值
  int _remainTime = 45; // 剩余时长
  int _millSecond= 0; // 剩余时长
  int _targetNumber = 1; // mcu主动上报击中的标靶
  String _showRemainTime = '00:45'; // 需要在UI上显示的剩余时长的格式
  /* get方法 */
  bool get powerOn => _powerOn;
  int get currentTarget => _currentTarget;
  int get score => _score;
  int get speed => _speed;
  int get powerValue => _powerValue;
  bool get gameStart => _gameStart;
  int get remainTime => _remainTime;
  int get millSecond => _millSecond;
  int get targetNumber => _targetNumber;

  String get showRemainTime => _showRemainTime;
  /* set方法*/
  set powerOn(bool powerOn){
    _powerOn = powerOn;
  }

  set currentTarget(int currentTarget){
    _currentTarget = currentTarget;
  }

  set score(int score){
    _score = score;
  }

  set speed(int speed){
    _speed = speed;
  }

  set powerValue(int powerValue){
    _powerValue = powerValue;
  }

  set gameStart(bool gameStart){
    _gameStart = gameStart;
  }

  /*mcu主动上报击中的标靶*/
  set targetNumber(int targetNumber){
    _targetNumber = targetNumber;
  }

  set remainTime(int remainTime){
    _remainTime = remainTime;
    notifyListeners();
   // _millSecond = 99;
    // 自动处理显示的剩余时长格字符串
    _showRemainTime =  '00:' + _remainTime.toString().padLeft(2, '0') + _millSecond.toString().padLeft(2, '0');
  }

  set millSecond(int millSecond){
    _millSecond = millSecond;
    notifyListeners();
    _showRemainTime =  '00:' + _remainTime.toString().padLeft(2, '0') + _millSecond.toString().padLeft(2, '0');
  }

  set showRemainTime(String showRemainTime){
    _showRemainTime = showRemainTime;
  }


}

// 创建一个全局的Provider
class GamedDataProvider extends StatelessWidget {
  final Widget child;

  GamedDataProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameData(),
      child: child,
    );
  }

  static GameData of(BuildContext context) {
    return Provider.of<GameData>(context, listen: false);
  }

}

