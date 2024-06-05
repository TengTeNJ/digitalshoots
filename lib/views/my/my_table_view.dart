import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';

class MyTableView extends StatelessWidget {
  List<String> data;
 Function? playVideo;
  MyTableView({required this.data,this.playVideo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 64 - 12,
      height: 96,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Constants.baseStyleColor, width: 1)),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Constants.boldBlackItalicTextWidget('Date', 12),
                flex: 1,
              ),
              Expanded(
                child: Constants.boldBlackItalicTextWidget('Scores', 12),
                flex: 1,
              ),
              Expanded(
                child: Constants.boldBlackItalicTextWidget('Speed', 12),
                flex: 1,
              ),
              Expanded(
                child: Constants.boldBlackItalicTextWidget('Video', 12),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 4,right: 4),
            height: 1,
            color: Constants.baseStyleColor,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Constants.boldBlackItalicTextWidget(data[0], 12),
                flex: 1,
              ),
              Expanded(
                child: Constants.boldBlackItalicTextWidget(data[1], 12),
                flex: 1,
              ),
              Expanded(
                child: Constants.boldBlackItalicTextWidget(data[2], 12),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.play_circle_fill_sharp,
                    size: 20,
                    color: Constants.baseStyleColor,
                  ),
                  onTap: (){
                    // 播放视频
                    if(playVideo != null){
                      playVideo!();
                    }
                  },
                ),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            margin: EdgeInsets.only(left: 4,right: 4),
            height: 1,
            color: Constants.baseStyleColor,
          ),
        ],
      ),
    );
  }
}
