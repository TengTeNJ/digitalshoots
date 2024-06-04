import 'package:flutter/material.dart';
import 'package:robot/views/tracking/bar_view.dart';

import '../../constants/constants.dart';
import '../../model/game_model.dart';
import '../../route/route.dart';
import '../../utils/local_data_util.dart';
import '../../utils/navigator_util.dart';
import '../../utils/toast.dart';
import '../base/avatar_view.dart';

class TrackingSpeedView extends StatefulWidget {
  const TrackingSpeedView({super.key});

  @override
  State<TrackingSpeedView> createState() => _TrackingSpeedViewState();
}

class _TrackingSpeedViewState extends State<TrackingSpeedView> {
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
                Constants.boldBlackItalicTextWidget('SPEED', 20),
                AvatarView()
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Constants.boldWhiteTextWidget('Shoot', 26),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Constants.boldWhiteTextWidget(_datas.length > 0 ? _datas.first.speed : '-', 30,height: 0.8),
                          SizedBox(width: 2,),
                           Constants.boldWhiteTextWidget('km/h', 14,height: 1.0),
                        ],
                      ),
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
            padding: EdgeInsets.only(left: 16, right: 16),
            child: MyStatsBarChatView(
              datas: _datas,
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
