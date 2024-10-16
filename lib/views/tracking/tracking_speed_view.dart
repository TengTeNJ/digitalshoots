import 'package:flutter/material.dart';
import 'package:robot/views/tracking/bar_view.dart';

import '../../constants/constants.dart';
import '../../model/game_model.dart';

class TrackingSpeedView extends StatefulWidget {
  const TrackingSpeedView({super.key});

  @override
  State<TrackingSpeedView> createState() => _TrackingSpeedViewState();
}

class _TrackingSpeedViewState extends State<TrackingSpeedView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.boldBlackItalicTextWidget('SPEED', 20),
                Image(
                  image: AssetImage('images/header.png'),
                  width: 50,
                  height: 50,
                )
              ],
            ),
          ),
          //  padding: EdgeInsets.only(left: 16,right: 16,top: 24,bottom: 24),
          Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
              padding: EdgeInsets.only(left: 16, right: 16),
              width: Constants.screenWidth(context) - 32,
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(16)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 36,
                      ),
                      Constants.regularWhiteTextWidget('Shoot', 14),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Constants.boldWhiteTextWidget('100', 20,height: 0.8),
                          SizedBox(width: 8,),
                           Constants.boldWhiteTextWidget('km/h', 12,height: 1.0),
                        ],
                      ),
                      SizedBox(
                        height: 36,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 36,
                      ),
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget('Today', 14),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Constants.regularWhiteTextWidget('Video', 14),
                          SizedBox(
                            width: 4,
                          ),
                          Icon(
                            Icons.play_circle_fill_sharp,
                            size: 16,
                            color: Colors.white,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 36,
                      ),
                    ],
                  ),
                ],
              )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: MyStatsBarChatView(
              datas: [
                Gamemodel(score: '100', indexString: '1', speed: '30'),
                Gamemodel(score: '56', indexString: '2', speed: '200')
              ],
            ),
          )),
          SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }
}
