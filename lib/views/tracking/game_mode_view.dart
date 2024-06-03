import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/views/tracking/recording_check_view.dart';
import 'package:robot/widges/base/rich_span_text.dart';

class GameModeView extends StatelessWidget {
  Function? play;
  Function? recordSelect;
  bool containRecording;
  int modeID;
  final _titles = ['Mode 1:Novice', 'Mode 2:Junior', 'Mode 3:Battle'];
  final _middle_titles = ['Single Play', 'Blue Target 15', 'Guest Blue'];
  final _bottom_titles = ['Blue Target', 'Red Target 20', 'Guest Red'];

  GameModeView({required this.modeID,this.play,this.containRecording = false,this.recordSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
       onTap: (){
        if(play != null){
          // 进入到游戏页面
          play!();
        }
       },
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(2),
          image: DecorationImage(
              image: AssetImage('images/gamemodel/model${modeID}.png'),
              fit: BoxFit.fill),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Constants.customTextWidget(_titles[modeID - 1], 16, '#ffffff'),
                  Constants.customTextWidget('75 Seconds', 16, 'ff0000')
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  RichSpanText(
                      text: _middle_titles[modeID - 1],
                      filterText: 'Blue',
                      filterTextColor: Colors.blue),
                  Text('')
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  modeID == 1 ?  RichSpanText(
                      text: _bottom_titles[modeID - 1],
                      filterText: 'Blue',
                      filterTextColor: Colors.blue) : RichSpanText(
                      text: _bottom_titles[modeID - 1],
                      filterText: 'Red',
                      filterTextColor: Colors.red),
                  Text('')
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Image(
                image: AssetImage('images/gamemodel/play${modeID}.png'),
                height: 36,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 4,),
              containRecording == true ? RecordingCheckView(onSelected: (value){
                if(recordSelect!=null){
                  recordSelect!(value);
                }
              },) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
