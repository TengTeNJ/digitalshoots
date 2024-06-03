import 'package:flutter/material.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/views/tracking/tracking_score_view.dart';
import 'package:robot/views/tracking/tracking_speed_view.dart';

class TrackingController extends StatefulWidget {
  const TrackingController({super.key});

  @override
  State<TrackingController> createState() => _TrackingControllerState();
}

class _TrackingControllerState extends State<TrackingController> {
  final _widgetList = [TrackingScoreView(),TrackingSpeedView()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BaseViewController(
      showBottomBar: false,
      child:  PageView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return _widgetList[index];
          }),
    );
  }
}
