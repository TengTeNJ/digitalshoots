import 'package:flutter/cupertino.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/utils/local_data_util.dart';

import '../constants/constants.dart';

class GameDataUtil {
  /*得分转换成星级 在我的账号页面使用*/
  static int scoreToStar(String score) {
    int _score = int.parse(score);
    if (_score > 0 && _score < 50) {
      return 1;
    } else if (_score >= 50 && _score < 100) {
      return 2;
    } else if (_score >= 100 && _score < 150) {
      return 3;
    } else if (_score >= 150 && _score <= 200) {
      return 4;
    }
    if (_score > 200) {
      return 5;
    }
    return 0;
  }

  /*得分转level 在My Stats页面使用*/
  static Future<int> scoreToLevel() async {
    Gamemodel _recentModel = await LocalDataUtil.getRecentData();
    if (_recentModel.score == '-') {
      return 0;
    }
    int _score = int.parse(_recentModel.score);
    if (_score > 0 && _score < 75) {
      return 1;
    } else if (_score >= 75 && _score < 150) {
      return 2;
    } else if (_score >= 150 && _score < 225) {
      return 3;
    } else if (_score >= 225) {
      return 4;
    }
    return 0;
  }

/*速度转level 在My Stats页面使用*/
  static Future<int> speedToLevel() async {
    Gamemodel _recentModel = await LocalDataUtil.getRecentData();
    if (_recentModel.speed == '-') {
      return 0;
    }
    int _speed = int.parse(_recentModel.speed);
    if (_speed > 0 && _speed < 50) {
      return 1;
    } else if (_speed >= 50 && _speed < 80) {
      return 2;
    } else if (_speed >= 80) {
      return 3;
    }
    return 0;
  }

  /*得分转换成进度条等级 在MyStats页面使用*/
  static Future<int> scoreToProgress() async {
    Gamemodel _recentModel = await LocalDataUtil.getRecentData();
    if (_recentModel.score == '-') {
      return 1;
    }
    int _score = int.parse(_recentModel.score);
    if (_score > 0 && _score < 75) {
      return 1;
    } else if (_score >= 75 && _score < 150) {
      return 2;
    } else if (_score >= 150 && _score < 225) {
      return 3;
    } else if (_score >= 225) {
      return 4;
    }
    return 1;
  }

  /*得分转换为进度条上面的倒立三角的进度(距离左侧的距离) 在MyStats页面使用*/
  static Future<double> scoreToProgressMarginleft(BuildContext context) async {
    // 进度条的宽度
    double _width =  Constants.screenWidth(context) - 52;
    // 每个等级的平均宽度
    double _averageWidth = _width/4;
    Gamemodel _recentModel = await LocalDataUtil.getRecentData();
    if (_recentModel.score == '-') {
      return 5;
    }
    int _score = int.parse(_recentModel.score);
    if (_score > 0 && _score < 75) {
      return _score/75 *_averageWidth + 5;
    } else if (_score >= 75 && _score < 150) {
      return (_score-75)/75 *_averageWidth + _averageWidth + 5;
    } else if (_score >= 150 && _score < 225) {
      return (_score - 150)/75 *_averageWidth + _averageWidth * 2 + 5;
    } else if (_score >= 225) {
      double tempWidth = (_score - 225)/75 *_averageWidth + _averageWidth * 3;
      if(tempWidth > _width){
        tempWidth  = _width;
      }
      return tempWidth + 5;
    }
    return 5;
  }

  /*电池电量转换为显示的图片的名称*/
  static int powerValueToBatteryImageLevel(int powerValue ){
    if(powerValue<=30){
      return 0;
    }else  if( powerValue>0 && powerValue<=46){
      return 20;
    }else  if( powerValue>46 && powerValue<=60){
      return 40;
    }else  if( powerValue>60 && powerValue<=70){
      return 60;
    }else  if( powerValue>70 && powerValue<=80){
      return 80;
    }else  if( powerValue>80){
      return 100;
    }else {
      return 100;
    }
  }

  static String boardPowerValueToBatteryImageLevel(int powerValue ){
    if(powerValue<=20){
      return 'red';
    }else if( powerValue>= 20 && powerValue<=70){
      return 'yellow';
    }else if( powerValue>70){
      return 'green';
    } else {
      return 'green';
    }
  }


}
