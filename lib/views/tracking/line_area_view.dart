import 'package:flutter/material.dart';
import 'package:robot/model/game_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/constants.dart';
import '../../utils/color.dart';
import '../base/empty_view.dart';

class MyStatsLineAreaView extends StatefulWidget {
  List<Gamemodel> datas = [];

  MyStatsLineAreaView({required this.datas});

  @override
  State<MyStatsLineAreaView> createState() => _MyStatsLineAreaViewState();
}

class _MyStatsLineAreaViewState extends State<MyStatsLineAreaView> {
  TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
    builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
        int seriesIndex) {
      Gamemodel model = data as Gamemodel;
      return Container(
        width: 130,
        height: 100,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Constants.regularBaseTextWidget('Score', 12),
                Constants.regularBaseTextWidget(model.score, 12),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Constants.regularBaseTextWidget('Date', 12),
                Constants.regularBaseTextWidget(model.createTime, 12),
              ],
            )
          ],
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
   return widget.datas.length > 0 ? SfCartesianChart(
     title: ChartTitle(
         text: 'TOP 10 RECORDS TODAY',
         textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),


     margin: EdgeInsets.only(left: 0, right: 0, top: 10),
     // legend: Legend(isVisible: true),
     selectionType: SelectionType.point,
     plotAreaBorderColor: Colors.transparent,
     // 控制和Y交叉方向的直线的样式
     primaryYAxis: NumericAxis(
         edgeLabelPlacement: EdgeLabelPlacement.none,
         // 移除左侧的填充
         labelStyle: TextStyle(
           color: hexStringToColor('#B1B1B1'),
           fontSize: 14,
           fontFamily: 'SanFranciscoDisplay',
           fontWeight: FontWeight.w400,
         ),
         maximum: 300,
         axisLine: AxisLine(width: 2, color: Colors.transparent),
         // 设置 X 轴轴线颜色和宽度
         labelPosition: ChartDataLabelPosition.outside,
         plotOffset: 0,
         interval: 30,
         majorTickLines: MajorTickLines(color: Colors.yellow, size: 0),
         // 超出坐标系部分的线条设置
         majorGridLines: MajorGridLines(
             color: Color.fromRGBO(112, 112, 112, 1.0),
             dashArray: [5, 5]) // 设置Y轴网格竖线为虚线,
     ),
     // backgroundColor: Color.fromRGBO(41, 41, 54, 1.0),
     onSelectionChanged: (SelectionArgs args) {
       //selectedIndexes.clear(); // 清空之前选中的索引
     },
     primaryXAxis: CategoryAxis(
       labelStyle: TextStyle(
         color: hexStringToColor('#B1B1B1'),
         fontSize: 14,
         fontFamily: 'SanFranciscoDisplay',
         fontWeight: FontWeight.w400,
       ),
       axisLine: AxisLine(width: 1, color: Color.fromRGBO(112, 112, 112, 1.0)),
       // 设置 X 轴轴线颜色和宽度
       labelPosition: ChartDataLabelPosition.outside,
       //interval: 2,
       majorGridLines:
       MajorGridLines(color: Colors.transparent, dashArray: [5, 5]),
       majorTickLines:
       MajorTickLines(color: Colors.yellow, size: 0), // 超出坐标系部分的线条设置
     ),
     tooltipBehavior: _tooltipBehavior,
     series: <CartesianSeries<Gamemodel, String>>[
       AreaSeries(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               Color.fromRGBO(251, 186, 0, 0.4),
               hexStringToOpacityColor('#9A7719', 0.4)
             ],
           ),
           // color: Colors.green,
           borderColor: Constants.baseStyleColor,
           // 设置边界线颜色
           borderWidth: 2,
           // 设置边界线宽度
           // 这里是选中的折线的颜色
           // 这里是选中的折线的颜色
           selectionBehavior: SelectionBehavior(
             enable: true,
             selectedColor: Colors.green,
             selectedBorderColor: Colors.green,
             selectedBorderWidth: 2,
             toggleSelection: false,
           ),
           markerSettings: MarkerSettings(
             isVisible: true,
             borderColor: Constants.baseStyleColor,
             shape: DataMarkerType.circle,
             // 设置数据点为圆形
             color: Constants.baseStyleColor,
             // 设置数据点颜色
             height: 6,
             // 设置数据点高度
             width: 6, // 设置数据点宽度
           ),

           dataSource: widget.datas,
           pointColorMapper: (Gamemodel data, _) => Colors.yellow,
           xValueMapper: (Gamemodel data, _) => data.indexString,
           yValueMapper: (Gamemodel data, _) =>
           int.parse(data.score) > 300 ? 300 : int.parse(data.score)),
     ],
   ) : EmptyView();

  }
}
