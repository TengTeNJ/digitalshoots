import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';

class MyStatsBottomView extends StatelessWidget {
  const MyStatsBottomView({super.key});

  @override
  Widget build(BuildContext context) {
    final temp_height = (Constants.screenHeight(context) -
            Constants.appBarHeight -
            Constants.tabBarHeight -
            64) /
        3.0;
    return Container(
      decoration: BoxDecoration(
        color: Constants.geryBGColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            child:
                Constants.boldBlackItalicTextWidget('YOU\'RE IN PROGRESS', 20),
            left: 0,
            right: 0,
            top: 24,
          ),
          Positioned(
            left: 0,
            right: 0,
            //top: (temp_height - 10 - ((Constants.screenWidth(context) - 52) *46/912) - 12 - 20) / 2.0,
            bottom: (temp_height -
                    10 -
                    ((Constants.screenWidth(context) - 52) * 46 / 912) -
                    12 -
                    20) /
                2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Image(
                    image: AssetImage('images/triangle-1.png'),
                    height: 10,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Image(
                    image: AssetImage('images/progress.png'),
                    width: Constants.screenWidth(context) - 52,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Constants.boldBlackItalicTextWidget('Poor', 16),flex: 1,),
                    Expanded(
                      child: Constants.boldBlackItalicTextWidget('', 16),flex: 1,),
                    Expanded(
                      child: Constants.boldBlackItalicTextWidget('Avg', 16),flex: 1,),
                    Expanded(
                      child: Constants.boldBlackItalicTextWidget('Excellent', 16),flex: 1,)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
