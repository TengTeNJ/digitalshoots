import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/utils/local_data_util.dart';
import 'package:robot/views/base/avatar_view.dart';
import 'package:robot/views/tracking/line_area_view.dart';
import 'dart:io';

import '../../route/route.dart';
import '../../utils/navigator_util.dart';
import '../../utils/toast.dart';
class TrackingScoreView extends StatefulWidget {
  const TrackingScoreView({super.key});

  @override
  State<TrackingScoreView> createState() => _TrackingScoreViewState();
}

class _TrackingScoreViewState extends State<TrackingScoreView> {
   List<Gamemodel> _datas = [];

   @override
   void initState() {
    // TODO: implement initState
    super.initState();
    getBestHistotyDatas();
  }

  getBestHistotyDatas() async{
     final _list =  await  LocalDataUtil.getHistoryBestTenDatas();
     _datas.addAll(_list);
     setState(() {

     });
  }
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
               AvatarView(),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Constants.boldWhiteTextWidget('Score', 26),
                      SizedBox(
                        height: 10,
                      ),
                      Constants.boldWhiteTextWidget(_datas.length > 0 ? _datas.first.score : '-', 26),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Constants.boldWhiteTextWidget('Today', 20),
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
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Constants.regularWhiteTextWidget('Video', 20),
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
                        onTap: (){
                          if(_datas.length == 0){
                            TTToast.showToast('No video');
                          }else if(_datas.first.path.length == 0){
                            TTToast.showToast('No video');
                          }else{
                            NavigatorUtil.push(Routes.videoplay,arguments: _datas.first.path);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              )),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16),
                child: MyStatsLineAreaView(
                  datas: _datas,
                ),
              )),
          SizedBox(height: 24,)
        ],
      ),
    );
  }
}
