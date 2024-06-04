import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:robot/model/user_info.dart';
import 'package:robot/utils/global.dart';
import 'package:robot/utils/notification_bloc.dart';
import 'package:robot/utils/string_util.dart';
import 'package:robot/views/base/avatar_view.dart';

import '../../constants/constants.dart';
import 'dart:io';

class MyStatsTopView extends StatefulWidget {
  String imagePath;

  MyStatsTopView({this.imagePath = ''});

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
          SizedBox(
            height: 12,
          ),
          AvatarView(
            onTap: () {
              // 跳转至tracking页
              GameUtil gameUtil = GetIt.instance<GameUtil>();
              gameUtil.currentPage = 3;
              EventBus().sendEvent(kStatsToTracking);
            },
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              // 跳转至tracking页
              GameUtil gameUtil = GetIt.instance<GameUtil>();
              gameUtil.currentPage = 1;
              EventBus().sendEvent(kStatsToTracking);
            },
            child: Container(
              padding: EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border:
                      Border.all(color: Constants.baseStyleColor, width: 1)),
              child: Constants.mediumBaseTextWidget('Tracking', 14),
            ),
            behavior: HitTestBehavior.opaque,
          ),
          SizedBox(
            height: 6,
          ),
          Consumer<UserModel>(builder: (context, userModel, child) {
            return Constants.mediumBaseTextWidget(
                StringUtil.serviceStringToShowDateString(userModel.brith), 14,
                height: 1.0);
          })
        ],
      ),
    );
  }
}
