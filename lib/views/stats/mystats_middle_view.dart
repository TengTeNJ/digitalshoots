import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:robot/constants/constants.dart';

import '../my/circle_view.dart';
class MyStatsMiddleView extends StatelessWidget {
  int scoreLevel ; //  得分等级
  int speedLevel ; // 速度等级
  String score;
  String speed;
  MyStatsMiddleView({this.scoreLevel = 0,this.speedLevel = 0,this.score = '-',this.speed='-'});

  @override
  Widget build(BuildContext context) {
    final temp_width = (Constants.screenWidth(context) - 32 - 32 - 64 ) / 2.0;
    final temp_height = (Constants.screenHeight(context) -  Constants.appBarHeight - Constants.tabBarHeight - 64)/3.0;
    return Container(
      margin: EdgeInsets.only(left: 16,right: 16),
      child: Row(
        children: [
          Container(
            // color: Colors.red,
            width: Constants.screenWidth(context) - 32 - 32,
            height: temp_height,
            child: Row(
              children: [
                Container(
                  child: Stack(children: [
                    CustomRing(currentLeve: scoreLevel,count: 4,width: temp_width,height: temp_height - 24,),
                    Positioned(child: Constants.boldBlackItalicTextWidget(score, 20),
                      left: (temp_width - 40) / 2.0,
                      right: (temp_width - 40) / 2.0,
                      top: (temp_height - 24 - 20)/2.0,
                      bottom: (temp_height - 24 - 20)/2.0,
                    ),
                    Positioned(child: Constants.customItalicTextWidget('Score', 20 , Constants.baseGreenStyleColor, fontWeight: FontWeight.bold),
                      left: (temp_width - 60) / 2.0,
                      bottom: 4,
                    ),
                  ],),
                ),
                SizedBox(width: 64),
                Stack(children: [
                  CustomRing(currentLeve: speedLevel,count: 3,width: temp_width ,height: temp_height - 24,),
                  Positioned(child: Image(image:  speed!='-' && int.parse(speed) > 50  ?  AssetImage('images/good.png') : AssetImage('images/poor.png'),width: 30,height: 30,),
                    left: (temp_width - 80) / 2.0,
                    right: (temp_width - 80) / 2.0,
                    top: 44,
                  ),
                  Positioned(child: Constants.boldBlackItalicTextWidget(speed, 20),
                    left: (temp_width - 40) / 2.0,
                    right: (temp_width - 40) / 2.0,
                    top: (temp_height - 24 - 20)/2.0,
                    bottom: (temp_height - 24 - 20)/2.0,
                  ),
                  Positioned(child: Constants.customItalicTextWidget('Speed', 20, Constants.baseGreenStyleColor,fontWeight: FontWeight.bold),
                    left: (temp_width - 60) / 2.0,
                    bottom: 4,
                  ),
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}
