import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:robot/constants/constants.dart';

import '../my/circle_view.dart';
class MyStatsMiddleView extends StatelessWidget {
  const MyStatsMiddleView({super.key});

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
                    CustomRing(currentLeve: 1,count: 4,width: temp_width,height: temp_height - 24,),
                    Positioned(child: Constants.boldBlackItalicTextWidget('0', 20),
                      left: (temp_width - 20) / 2.0,
                      right: (temp_width - 20) / 2.0,
                      top: (temp_height - 24 - 20)/2.0,
                      bottom: (temp_height - 24 - 20)/2.0,
                    ),
                    Positioned(child: Constants.boldBlackItalicTextWidget('Score', 20),
                      left: (temp_width - 60) / 2.0,
                      bottom: 0,
                    ),
                  ],),
                ),
                SizedBox(width: 64),
                Stack(children: [
                  CustomRing(currentLeve: 0,count: 3,width: temp_width ,height: temp_height - 24,),
                  Positioned(child: Image(image: AssetImage('images/good.png'),width: 30,height: 30,),
                    left: (temp_width - 80) / 2.0,
                    right: (temp_width - 80) / 2.0,
                    top: 44,
                  ),
                  Positioned(child: Constants.boldBlackItalicTextWidget('0', 20),
                    left: (temp_width - 20) / 2.0,
                    right: (temp_width - 20) / 2.0,
                    top: (temp_height - 24 - 20)/2.0,
                    bottom: (temp_height - 24 - 20)/2.0,
                  ),
                  Positioned(child: Constants.boldBlackItalicTextWidget('Speed', 20),
                    left: (temp_width - 60) / 2.0,
                    bottom: 0,
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
