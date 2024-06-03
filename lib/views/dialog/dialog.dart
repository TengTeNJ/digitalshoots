import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
class UserNameDialog extends StatefulWidget {
  Function? confirm;
  String? des;
  String? placeHolderText;

  UserNameDialog({this.confirm,this.des,this.placeHolderText});

  @override
  State<UserNameDialog> createState() => _UserNameDialogState();
}

class _UserNameDialogState extends State<UserNameDialog> {
  TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: hexStringToColor('#ffffff'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Constants.boldBlackItalicTextWidget( widget.placeHolderText ??  'Enter your text', 20,
          textAlign: TextAlign.left),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            controller: _usernameController,
            decoration: InputDecoration(
                labelText: widget.des ?? 'Username',
                labelStyle: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: Constants.baseGreyStyleColor,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Constants.regularWhiteTextWidget('Cancel', 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            String username = _usernameController.text;
            if (widget.confirm != null) {
              widget.confirm!(username);
            }
            Navigator.of(context).pop();
          },
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
                color: Constants.baseStyleColor,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Constants.regularWhiteTextWidget('Confirm', 16),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}