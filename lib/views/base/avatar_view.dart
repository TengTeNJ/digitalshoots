import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
class AvatarView extends StatefulWidget {
  Function? onTap;
   AvatarView({this.onTap});

  @override
  State<AvatarView> createState() => _AvatarViewState();
}

class _AvatarViewState extends State<AvatarView> {
  String fileImagePath = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryAvatar();
  }
  queryAvatar() async{
    final directory =  await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/user.png';
    final file = File(imagePath);
    if(file.existsSync()){
      // 头像存在
      fileImagePath = imagePath;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: GestureDetector(child: fileImagePath.length > 0 ? Image.file(File(fileImagePath),width: 50,height: 50,) : Image(
        image: AssetImage('images/header.png'),
        width: 50,
        height: 50,
      ),
        behavior: HitTestBehavior.opaque,
        onTap: (){
        if(widget.onTap != null){
          widget.onTap!();
        }
        },
      ),
    );
  }
}
