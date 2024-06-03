import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

}