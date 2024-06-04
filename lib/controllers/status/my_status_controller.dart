import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/model/game_data.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/utils/data_base.dart';
import 'package:robot/utils/game_data_util.dart';
import 'package:robot/utils/local_data_util.dart';
import 'package:robot/views/my/circle_view.dart';
import 'package:robot/views/stats/mystats_bottom_view.dart';
import 'package:robot/views/stats/mystats_middle_view.dart';
import 'package:robot/views/stats/mystats_top_view.dart';
import 'dart:io';

class MyStatusController extends StatefulWidget {
  const MyStatusController({super.key});

  @override
  State<MyStatusController> createState() => _MyStatusControllerState();
}

class _MyStatusControllerState extends State<MyStatusController> {
  String fileImagePath = '';
  int scoreLevel = 0;
  int speedLevel = 0;
  int level = 1;
  String score = '-';
  String speed = '-';
  double marginLeft = 5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalGamedata();
    queryAvatar();
  }
  queryAvatar() async{
    final directory =  await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/user.png';
    final file = File(imagePath);
    if(file.existsSync()){
      // 头像存在
      fileImagePath = imagePath;
      setState(() {

      });
    }
  }
  getLocalGamedata() async {
    scoreLevel = await GameDataUtil.scoreToLevel();
    speedLevel = await GameDataUtil.speedToLevel();
    level = await GameDataUtil.scoreToProgress();
    marginLeft = await GameDataUtil.scoreToProgressMarginleft(context);
    final _model =  await LocalDataUtil.getRecentData();
    score = _model.score;
    speed = _model.speed;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseViewController(
      showBottomBar: false,
      child: Padding(
        padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
        child: Column(
          children: [
            Expanded(
              child: MyStatsTopView(imagePath: fileImagePath,),
              flex: 1,
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                color: Constants.geryBGColor,
                child: MyStatsMiddleView(scoreLevel: scoreLevel,speedLevel: speedLevel,score: score,speed: speed,),
              ),
              flex: 1,
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: MyStatsBottomView(level: level,marginLeft: marginLeft,),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
