import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';

class SpeedView extends StatefulWidget {
  String speed;
  SpeedView({required this.speed});

  @override
  State<SpeedView> createState() => _SpeedViewState();
}

class _SpeedViewState extends State<SpeedView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: Constants.screenWidth(context) - 64,
      decoration: BoxDecoration(
          color: Constants.baseStyleColor,
          borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Positioned(
              left: 56,
              right: 56,
              top: 6,
              child: Constants.mediumWhiteTextWidget('SHOTS', 20,
                  textAlign: TextAlign.left)),
       
           
            Positioned(
              left: 56,
              right: 56,
              top: 0,
              bottom: 0,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Constants.mediumWhiteTextWidget('S P E E D', 20),
                Constants.digiRegularWhiteTextWidget(widget.speed.padLeft(3,'0'), 60)
              ],
            ),)
          
        ],
      ),
    );
  }
}
