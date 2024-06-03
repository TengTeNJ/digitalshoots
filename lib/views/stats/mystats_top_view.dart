import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot/model/user_info.dart';
import 'package:robot/utils/string_util.dart';

import '../../constants/constants.dart';
class MyStatsTopView extends StatefulWidget {
  const MyStatsTopView({super.key});

  @override
  State<MyStatsTopView> createState() => _MyStatsTopViewState();
}

class _MyStatsTopViewState extends State<MyStatsTopView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.screenWidth(context) - 32,
        decoration: BoxDecoration(
        color: Constants.geryBGColor,
        borderRadius: BorderRadius.circular(10),
    ),
      child: Column(
          children: [
            SizedBox(height: 12,),
            Image(image: AssetImage('images/header.png'),width: 50,height: 50,),
            SizedBox(height: 16,),
            Container(
                padding: EdgeInsets.only(top: 6,bottom: 6,left: 12,right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Constants.baseStyleColor,width: 1)
                ),
                child: Constants.mediumBaseTextWidget('Tracking', 14),
              ),
            SizedBox(height: 6,),
            Consumer<UserModel>(builder: (context,userModel,child){
              return Constants.mediumBaseTextWidget(StringUtil.serviceStringToShowDateString(userModel.brith), 14,height: 1.0);
            })
          ],
      ),
    );
  }
}
