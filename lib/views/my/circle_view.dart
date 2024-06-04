import 'dart:math';
import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';

class CustomRingPainter extends CustomPainter {
  final int count;
   int currentLeve;
  CustomRingPainter({required this.count,this.currentLeve = 0});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 7.0;
    double radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    double startAngle = 3 * pi / 4 + pi*27/(this.count*2*180) ; // -90 degrees in radians
    double sweepAngle = pi * 3/2 ; // 270 degrees in radians

    double anglePerSection = sweepAngle / this.count;

    for (int i = 0; i < this.count; i++) {
      Paint paint = Paint()
        ..color =    i+1 > currentLeve ? Constants.baseGreyStyleColor : Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
        startAngle + i * anglePerSection,
        anglePerSection * 0.9, // Adjust this value to control the gap between sections
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomRing extends StatelessWidget {
  final int count;
  int currentLeve;
  double width;
  double height;
  CustomRing({required this.count,this.currentLeve = 0,this.width = 100, this.height = 100});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SizedBox(
          width: width,
          height: height,
          child: CustomPaint(
            painter: CustomRingPainter(
              count: count,
              currentLeve: currentLeve
            ),
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Ring Example'),
//       ),
//       body: CustomRing(),
//     ),
//   ));
// }
