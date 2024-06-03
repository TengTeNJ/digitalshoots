import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/utils/data_base.dart';
import 'package:robot/views/my/circle_view.dart';
import 'package:robot/views/stats/mystats_bottom_view.dart';
import 'package:robot/views/stats/mystats_middle_view.dart';
import 'package:robot/views/stats/mystats_top_view.dart';

class MyStatusController extends StatefulWidget {
  const MyStatusController({super.key});

  @override
  State<MyStatusController> createState() => _MyStatusControllerState();
}

class _MyStatusControllerState extends State<MyStatusController> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalGamedata();
  }

  getLocalGamedata() async{
     List<Gamemodel> _list =  await DatabaseHelper().getData(kDataBaseTableName);
     print('length=${_list.length}');
     if(_list.length > 0){
       print('_list.first.score=${_list.first.score}');
     }
  }

  @override
  Widget build(BuildContext context) {
    return BaseViewController(
      showBottomBar: false,
      child: Padding(
        padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
        child: Column(
          children: [
            Expanded(child: MyStatsTopView(),flex: 1,),
            SizedBox(height: 12,),
            Expanded(child: Container(color:Constants.geryBGColor ,child:MyStatsMiddleView(),),flex: 1,),
            SizedBox(height: 12,),
            Expanded(child: MyStatsBottomView(),flex: 1,),
          ],
        ),
      ),
    );
  }
}
