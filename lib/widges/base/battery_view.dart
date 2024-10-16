import 'package:flutter/material.dart';

class BatteryView extends StatefulWidget {

  List<String> batteryImageNames;

  BatteryView({required this.batteryImageNames});
  @override
  State<BatteryView> createState() => _BatteryViewState();
}

class _BatteryViewState extends State<BatteryView> {
  @override
  Widget build(BuildContext context) {

    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Image(
              image: AssetImage('${widget.batteryImageNames[0]}'),
              height: 12,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(width: 5,),
            Image(
              image: AssetImage('${widget.batteryImageNames[1]}'),
              height: 12,
              fit: BoxFit.fitHeight,
            ),

            SizedBox(width: 5,),
            Image(
              image: AssetImage('${widget.batteryImageNames[2]}'),
              height: 12,
              fit: BoxFit.fitHeight,
            ),

            SizedBox(width: 5,),
            Image(
              image: AssetImage('${widget.batteryImageNames[3]}'),
              height: 12,
              fit: BoxFit.fitHeight,
            ),

            SizedBox(width: 5,),
            Image(
              image: AssetImage('${widget.batteryImageNames[4]}'),
              height: 12,
              fit: BoxFit.fitHeight,
            ),

            SizedBox(width: 5,),
            Image(
              image: AssetImage('${widget.batteryImageNames[5]}'),
              height: 12,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(width: 5,),
      ],

    );
  }
}
