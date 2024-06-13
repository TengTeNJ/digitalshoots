
import 'package:flutter/material.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/views/base/empty_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/constants.dart';
import '../../route/route.dart';
import '../../utils/color.dart';
import '../../utils/navigator_util.dart';
import '../../utils/string_util.dart';

class MyStatsBarChatView extends StatefulWidget {
  List<Gamemodel> datas = [];

  MyStatsBarChatView({required this.datas});

  @override
  State<MyStatsBarChatView> createState() => _MyStatsBarChatViewState();
}

class _MyStatsBarChatViewState extends State<MyStatsBarChatView> {
  late TooltipBehavior _tooltipBehavior;
  bool _disposed = false;

  void _callback(Duration duration) {
    if (!_disposed) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      // shouldAlwaysShow: true,
      canShowMarker: false,
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        Gamemodel model = data as Gamemodel;
        return Container(
          width: 240,
          height: 100,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.boldBlackItalicTextWidget('Speed', 18),
                    Constants.mediumBaseTextWidget(model.speed, 18),
                  ],
                )),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Constants.boldBlackItalicTextWidget('Date', 18),
                    Constants.mediumBaseTextWidget( StringUtil.createTimeStringToTipShowString(model.createTime), 18),
                  ],
                )),
                model.path.length > 0 ?  GestureDetector(child: Row(
                  children: [
                    Icon(Icons.play_circle_fill_sharp,size: 40,color: Constants.baseStyleColor,)
                  ],
                ),behavior: HitTestBehavior.opaque,onTap: (){
                  print('model.path=${model.path}');
                  NavigatorUtil.push(Routes.videoplay,arguments: model.path);
                },) :Container(
                  child: Center(
                    child: Constants.regularGreyTextWidget('No video', 20),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /*选中柱形图*/
  // selectItem(MyStatsModel model) {
  //   widget.datas.forEach((MyStatsModel number) {
  //     number.selected = false;
  //   });
  //   model.selected = true;
  //   // 使用 SchedulerBinding.instance.addPostFrameCallback 来延迟调用 setState，以确保在构建完成后再更新状态
  //   WidgetsBinding.instance.addPersistentFrameCallback(_callback);
  // }

  @override
  Widget build(BuildContext context) {
    return widget.datas.length > 0 ? SfCartesianChart(
        title: ChartTitle(
            text: 'TOP 10 RECORDS TODAY',
            textStyle:
            TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),        margin:EdgeInsets.only(left: 0,right: 0,top: 10),
        plotAreaBorderWidth: 0,
        // 设置绘图区域的边框宽度为0，隐藏边框
        plotAreaBorderColor: Colors.transparent,
        // 设置绘图区域的边框颜色为透明色
        primaryYAxis: NumericAxis(
          labelStyle: TextStyle(
            color: hexStringToColor('#B1B1B1'),
            fontSize: 14,
            fontFamily: 'SanFranciscoDisplay',
            fontWeight: FontWeight.w400,
          ),
          maximum: 100,
          labelAlignment: LabelAlignment.center,
          interval: 10,
          axisLine: AxisLine(width: 1, color: Colors.transparent),
          // 设置 X 轴轴线颜色和宽度
          plotOffset: 0,
          labelPosition: ChartDataLabelPosition.outside,
          // labelStyle: TextStyle(fontSize: 12, color: Colors.black), // 设置标签样式
          majorGridLines: MajorGridLines(
              color: Color.fromRGBO(112, 112, 112, 1.0), dashArray: [5, 5]),
          majorTickLines: MajorTickLines(width: 0),

          //opposedPosition: true, // 将 Y 轴放置在图表的右侧
          // minimum: 0, // 设置 Y 轴的最小值为0
          // maximum: 50, // 设置 Y 轴的最大值
          // interval: 10, // 设置 Y 轴的间隔
          //  edgeLabelPlacement: EdgeLabelPlacement.shift, // 调整标签位置，使得第一个数据和 Y 轴有间隔
        ),
        primaryXAxis: CategoryAxis(
          labelStyle: widget.datas.length > 20
              ? TextStyle(
            color: hexStringToColor('#B1B1B1'),
            fontSize: 10,
            fontFamily: 'SanFranciscoDisplay',
            fontWeight: FontWeight.w400,
          )
              : TextStyle(
            color: hexStringToColor('#B1B1B1'),
            fontSize: 14,
            fontFamily: 'SanFranciscoDisplay',
            fontWeight: FontWeight.w400,
          ),
          plotOffset: 1,
          interval: 1,
          axisLine:
          AxisLine(width: 1, color: Color.fromRGBO(112, 112, 112, 1.0)),
          // 设置 X 轴轴线颜色和宽度
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          // 调整标签位置，使得第一个数据和 Y 轴有间隔
          majorGridLines:
          MajorGridLines(color: Colors.transparent, dashArray: [5, 5]),
          majorTickLines: MajorTickLines(width: 0),
          // minimum: 0, // 设置Y轴的最小值
          // maximum: 10, // 设置Y轴的最大值
        ),
        tooltipBehavior: _tooltipBehavior,
        series: <CartesianSeries<Gamemodel, num>>[
          // Renders column chart
          ColumnSeries<Gamemodel, num>(
              selectionBehavior: SelectionBehavior(
                enable: true, // 这个设置为true,会在选中时，其他的置灰
                // toggleSelection: false,
                //  overlayMode: ChartSelectionOverlayMode.top, // 设置选中视图显示在柱状图上面
              ),
              borderRadius: BorderRadius.circular(5),
              // 设置柱状图的圆角
              dataSource: widget.datas,
              width: 0.1,
              // 设置柱状图的宽度，值为 0.0 到 1.0 之间，表示相对于间距的比例
              spacing: 0.0,
              //
              xValueMapper: (Gamemodel data, _) =>
                  int.parse(data.indexString),
              yValueMapper: (Gamemodel data, _) =>
              int.parse(data.speed) > 100 ? 100 :  int.parse(data.speed),
              pointColorMapper: (Gamemodel data, _) =>
                  hexStringToColor('#F8850B'))
        ]) : EmptyView(title: 'There is no data for today.',);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }
}
