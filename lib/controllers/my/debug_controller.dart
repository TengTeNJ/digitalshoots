import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/model/user_info.dart';
import 'package:robot/utils/ble_send_util.dart';
import 'package:robot/utils/string_util.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:robot/utils/toast.dart';
import '../../utils/notification_bloc.dart';
class DebugController extends StatefulWidget {
  const DebugController({super.key});

  @override
  State<DebugController> createState() => _DebugControllerState();
}

class _DebugControllerState extends State<DebugController> {
  late StreamSubscription subscription;
  List<SelectedListItem> channelDatas = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) async{
    });
    initData();
  }

  initData(){
    for (int i = 0; i < kChannelArray.length; i++) {
      SelectedListItem item = SelectedListItem(name: '通道${kChannelArray[i]}');
      item.value = kChannelArray[i].toString();
      if (i == 2) {
        item.isSelected = true;
      }
      channelDatas.add(item);
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseViewController(
      showBottomBar: false,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // 阴影颜色
                    spreadRadius: 5.0, // 阴影的大小
                    blurRadius: 7.0, // 阴影的模糊度
                    offset: Offset(0, 3), // 阴影的偏移量
                  ),
                ],
              ),
              child: SingleChildScrollView(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                      height: 123,
                      child: ListView.builder(
                        itemBuilder: _itemBuilder,
                        itemCount: 2,
                      )),
                  Container(height: 0.5,color: Constants.baseGreyStyleColor,),
                  SizedBox(height: 32,),
                ],
              ),),
            ),
            left: 16,
            right: 16,
            top: 64,
            bottom: 32,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    const _titles = ['切换信道', '重置', ];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async{
        if(index == 0){
          DropDownState(
            heightOfBottomSheet: 500,
            DropDown(
              // isSearchVisible: false,
              bottomSheetTitle:
              Constants.boldBaseTextWidget('通信通道', 20),
              searchHintText: '搜索',
              data: channelDatas,
              onSelected: (List<dynamic> selectedList) {
                SelectedListItem item = selectedList.first;
                print('selectedList = ${selectedList}');
                BLESendUtil.changeChannelControl(int.parse(item.value!));
                TTToast.showSuccessInfo('切换信道数据发送成功');
              },
              enableMultipleSelection: false,
            ),
          ).showModal(context);
        }else if(index == 1){
          BLESendUtil.resetControl();
          TTToast.showSuccessInfo('重置数据发送成功');
        }
      },
      child: Column(
        children: [
          Container(height: 0.5,color: Constants.baseGreyStyleColor,),
          Consumer<UserModel>(builder: (context,userModel,child){
            return Container(
              height: 60,
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16),child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Constants.boldBlackItalicTextWidget(_titles[index], 16),
                  Row(
                    children: [
                      Constants.regularGreyTextWidget([userModel.team,userModel.userName, StringUtil.serviceStringToShowDateString(userModel.brith) ][index],14),
                      SizedBox(width: 4,),
                      Icon(Icons.arrow_forward_ios,size: 14,color: Constants.baseGreyStyleColor,)
                    ],
                  ),
                ],
              ),
              ),
            );
          })

        ],
      ),
    );
  }


}


