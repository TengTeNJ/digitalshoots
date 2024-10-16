import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/views/tracking/line_area_view.dart';

class TrackingScoreView extends StatefulWidget {
  const TrackingScoreView({super.key});

  @override
  State<TrackingScoreView> createState() => _TrackingScoreViewState();
}

class _TrackingScoreViewState extends State<TrackingScoreView> {
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
                Constants.boldBlackItalicTextWidget('PROFILE', 20),
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
                    children: [
                      SizedBox(
                        height: 36,
                      ),
                      Constants.regularWhiteTextWidget('Score', 14),
                      SizedBox(
                        height: 16,
                      ),
                      Constants.boldWhiteTextWidget('0', 16),
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
                padding: EdgeInsets.only(left: 16,right: 16),
                child: MyStatsLineAreaView(
                  datas: [Gamemodel(score: '100',indexString: '1'), Gamemodel(score: '56',indexString: '2')],
                ),
              )),
          SizedBox(height: 24,)
        ],
      ),
    );
  }
}
