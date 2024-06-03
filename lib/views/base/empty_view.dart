import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
class EmptyView extends StatelessWidget {
  String title;
   EmptyView({this.title = 'No data yet.'});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Constants.mediumGreyTextWidget(title, 16),
      ),
    );
  }
}
