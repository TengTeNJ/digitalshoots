import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/model/user_info.dart';
import 'package:robot/utils/nsuserdefault_util.dart';
import 'package:robot/utils/string_util.dart';
import 'package:robot/utils/tt_dialog.dart';
import 'package:robot/views/my/stars_view.dart';

class MyAccountController extends StatefulWidget {
  const MyAccountController({super.key});

  @override
  State<MyAccountController> createState() => _MyAccountControllerState();
}

class _MyAccountControllerState extends State<MyAccountController> {
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
                  StarsView(starPoint: 1)
                ],
              ),),
            ),
            left: 16,
            right: 16,
            top: 44,
            bottom: 32,
          ),
          Positioned(
              left: 0,
              right: 0,
              top: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: AssetImage('images/good.png'),
                  width: 30,
                  height: 30,
                ),
              ))
        ],
      ),
    );
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
                  Constants.regularGreyTextWidget([userModel.team,userModel.userName, StringUtil.serviceStringToShowDateString(userModel.brith) ][index],14),
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


