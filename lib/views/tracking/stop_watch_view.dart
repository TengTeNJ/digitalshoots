import 'dart:async';
import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
class StopWatchView extends StatefulWidget {
  String formaterText;
  StopWatchView({required this.formaterText});

  @override
  State<StopWatchView> createState() => _StopWatchViewState();
}

class _StopWatchViewState extends State<StopWatchView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Constants.digiRegularBaseTextWidget(widget.formaterText, 60),);
  }


  @override
  void dispose() {
    super.dispose();
  }
}
