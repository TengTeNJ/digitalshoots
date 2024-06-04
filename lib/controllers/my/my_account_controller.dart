import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/model/user_info.dart';
import 'package:robot/route/route.dart';
import 'package:robot/utils/data_base.dart';
import 'package:robot/utils/game_data_util.dart';
import 'package:robot/utils/local_data_util.dart';
import 'package:robot/utils/navigator_util.dart';
import 'package:robot/utils/nsuserdefault_util.dart';
import 'package:robot/utils/string_util.dart';
import 'package:robot/utils/toast.dart';
import 'package:robot/utils/tt_dialog.dart';
import 'package:robot/views/my/my_table_view.dart';
import 'package:robot/views/my/stars_view.dart';
import 'dart:io';

import '../../utils/notification_bloc.dart';
class MyAccountController extends StatefulWidget {
  const MyAccountController({super.key});

  @override
  State<MyAccountController> createState() => _MyAccountControllerState();
}

class _MyAccountControllerState extends State<MyAccountController> {
  late StreamSubscription subscription;
  Gamemodel maxModel = Gamemodel(score: '0', indexString: '1');
  String fileImagePath = '';
  List<String> datas = ['-','-','-'];
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      // barrierColor: hexStringToColor('#3E3E55'),
      lastDate: selectedDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        UserProvider.of(context).brith = StringUtil.dateTimeToString(selectedDate);
        NSUserDefault.setKeyValue(kBrithDay, StringUtil.dateTimeToString(selectedDate));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = EventBus().stream.listen((event) async{
      if(event == kUpdateAvatar){
      // 需要先清空一次这个变量 要不然因为路径没变化 刷新UI的话头像不会重新渲染
        setState(() {
          fileImagePath = '';
        });
        Future.delayed(Duration(milliseconds: 50),(){
        queryAvatar();
        });
      }
    });
    queryMaxModel();
    queryAvatar();
  }
  /*查询历史最大数据*/
  queryMaxModel() async{
    final _model = await  LocalDataUtil.getHistoryMaxScore();
    maxModel = _model;
    datas = [_model.createTime,_model.score, _model.speed];
    if(mounted){
      setState(() {

      });
    }
  }
  // 查询本地存储的头像
  queryAvatar() async{
    final directory =  await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/user.png';
    final file = File(imagePath);
    if(file.existsSync()){
      // 头像存在
      fileImagePath = imagePath;
      if(mounted){
        setState(() {

        });
      }
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
                      height: 183,
                      child: ListView.builder(
                        itemBuilder: _itemBuilder,
                        itemCount: 3,
                      )),
                  Container(height: 0.5,color: Constants.baseGreyStyleColor,),
                  SizedBox(height: 32,),
                  StarsView(starPoint: GameDataUtil.scoreToStar(maxModel.score)),
                  SizedBox(height: 24,),
                  MyTableView(data: datas,playVideo: (){
                    print('maxModel=${maxModel.path.length}');
                    if(maxModel.path.length > 0){
                      NavigatorUtil.push(Routes.videoplay,arguments: maxModel.path);
                    }else{
                      TTToast.showToast('No video');
                    }
                  },)
                ],
              ),),
            ),
            left: 16,
            right: 16,
            top: 64,
            bottom: 32,
          ),
          Positioned(
              left: (Constants.screenWidth(context) - 50) / 2.0,
              right: (Constants.screenWidth(context) - 50) / 2.0,
              top: 39,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: GestureDetector(child: fileImagePath.length > 0 ? Image.file(File(fileImagePath),width: 50,height: 50,) : Image(
                  image: AssetImage('images/header.png'),
                  width: 50,
                  height: 50,
                ),
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                  TTDialog.showBottomSheetCameraAndGallery(context);
                  },
                ),
              ))
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
    const _titles = ['TEAM', 'NAME', 'BRITHDAY'];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async{
        if(index == 0){
          TTDialog.teamDialog(context, (value){
            UserProvider.of(context).team = value;
            NSUserDefault.setKeyValue(kTeam, value);
          });
        }else if(index == 1){
          TTDialog.userNameDialog(context, (value){
            UserProvider.of(context).userName = value;
            NSUserDefault.setKeyValue(kUserName, value);
          });
        }else{
          final _brith =  await NSUserDefault.getValue(kBrithDay);
          if (_brith == null ||  _brith.length < 4) {
            selectedDate = DateTime.now();
          } else {
            selectedDate = StringUtil.stringToDate(_brith);
          }
          _selectDate(context);
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


