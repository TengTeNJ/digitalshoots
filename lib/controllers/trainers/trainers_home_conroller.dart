import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/route/route.dart';
import 'package:robot/utils/navigator_util.dart';
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
    print('-------');
    _controller = VideoPlayerController.asset('images/splash.mp4')..initialize().then((value) => (){
      print('---splash----');
      _controller.play();
    });
    _controller.play();
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
              NavigatorUtil.push(Routes.gamemodel);
            },
            child: Container(
              width: Constants.screenWidth(context) - 32,
              margin: EdgeInsets.only(left: 16,right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(image: AssetImage('images/good.png'),width: 30,height: 30,),
                  ),
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

