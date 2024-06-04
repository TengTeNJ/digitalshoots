
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/utils/image_util.dart';
import '../views/dialog/dialog.dart';


class TTDialog {
  //*修改UserName弹窗*/
  static userNameDialog(BuildContext context,Function confirm){
    return showDialog(context: context, builder: (context){
      return UserNameDialog(confirm: confirm,);
    });
  }
  /*修改Team弹窗*/
  static teamDialog(BuildContext context,Function confirm){
    return showDialog(context: context, builder: (context){
      return UserNameDialog(confirm: confirm,placeHolderText: 'Enter your team name',des: 'Team',);
    });
  }

  static showBottomSheetCameraAndGallery(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Take a photo'),
                  onTap: () {
                    // 打开相机
                    Navigator.pop(context);
                    openCamera();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Choose from gallery'),
                  onTap: () {
                    // 从相册选择图片
                    Navigator.pop(context);
                    openGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}