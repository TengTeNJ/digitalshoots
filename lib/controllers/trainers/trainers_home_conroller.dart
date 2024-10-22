import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/route/route.dart';
import 'package:robot/utils/blue_tooth_manager.dart';
import 'package:robot/utils/navigator_util.dart';
import 'package:robot/utils/toast.dart';
import 'package:robot/utils/tt_dialog.dart';
import 'package:robot/views/base/avatar_view.dart';
import 'package:video_player/video_player.dart';

class TrainersHomeController extends StatefulWidget {
  const TrainersHomeController({super.key});

  @override
  State<TrainersHomeController> createState() => _TrainersHomeControllerState();
}

class _TrainersHomeControllerState extends State<TrainersHomeController> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset('images/splash.mp4')..initialize().then((value) => (){_controller.play();
    });
    _controller.play();
    _controller.addListener((){
       if(_controller.value.isPlaying) {

       } else if (_controller.value.position == _controller.value.duration) {
         _controller.seekTo(Duration.zero);
         _controller.play();
       }
    });
    preLoadImage();
  }

  preLoadImage(){
    // 预加载下个页面的的几个模式的背景图片 防止每次启动初次加载会闪屏的显现象 应该是图片过大影响的
    Future.delayed(Duration(milliseconds: 100),(){
      precacheImage(
        ExactAssetImage('images/gamemodel/model1.png'),
        context,
      );
      precacheImage(
        ExactAssetImage('images/gamemodel/model2.png'),
        context,
      );
      precacheImage(
        ExactAssetImage('images/gamemodel/model3.png'),
        context,
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return BaseViewController(
      showBottomBar: false,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            width: Constants.screenWidth(context) - 32,
            child: ClipRRect(
              child: AspectRatio(
                aspectRatio: 1.4,
                child: VideoPlayer(_controller),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12)),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: (){
              int bleConectedCount = BluetoothManager().conectedDeviceCount.value;
              if(bleConectedCount <= 0){
                TTToast.showErrorInfo('Pls. Connect Digital Shooter Tutor Firstly！',duration: 3000);
              }else{
                NavigatorUtil.push(Routes.gamemodel);
              }
            },
            child: Container(
              width: Constants.screenWidth(context) - 32,
              margin: EdgeInsets.only(left: 16,right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 64,),
                 AvatarView(),
                  SizedBox(height: 32,),
                  Text('DIGITAL TRAINERS',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)
                ],
              ),
            ),
          )),
          SizedBox(height: 32,),
        ],
      ),
    );
  }
}

