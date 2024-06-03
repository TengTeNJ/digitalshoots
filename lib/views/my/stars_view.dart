import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';

class StarsView extends StatelessWidget {
  int starPoint = 1; // 几星
  StarsView({required this.starPoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: Constants.screenWidth(context),
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(starPoint, (index){
                  return Icon(
                    Icons.star,
                    size: 30,
                    color: Constants.baseStyleColor,
                  );
                }),
              ),
              Row(
                children: List.generate(5 - starPoint, (index){
                  return Icon(
                    Icons.star,
                    size: 30,
                    color: Constants.baseGreyStyleColor,
                  );
                }),
              ),
            ],
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Constants.baseStyleColor),
            child: Center(
              child: Padding(padding: EdgeInsets.all(6),child: Constants.boldWhiteItalicTextWidget('High Scores', 18),),
            ),
          )
        ],
      ),
    );
  }
}
