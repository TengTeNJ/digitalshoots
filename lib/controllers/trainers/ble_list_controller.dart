import 'package:flutter/material.dart';
import 'package:robot/constants/constants.dart';
import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:robot/utils/blue_tooth_manager.dart';
import 'package:robot/views/base/empty_view.dart';

class BLEListController extends StatefulWidget {
  const BLEListController({super.key});

  @override
  State<BLEListController> createState() => _BLEListControllerState();
}

class _BLEListControllerState extends State<BLEListController> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _list = BluetoothManager().deviceList;
    print('object');
  }
  @override
  Widget build(BuildContext context) {
    return BaseViewController(
      // showBottomBar: false,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constants.boldBlackItalicTextWidget('SETTING', 18),
            SizedBox(
              height: 12,
            ),
            Expanded(
                child: Container(
                  width: Constants.screenWidth(context) - 32,
              decoration: BoxDecoration(
                color: Constants.baseGreyStyleColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Constants.boldBaseTextWidget('BLUETOOTH', 18),
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(child: Container(
                    width: Constants.screenWidth(context) - 64,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 12,),
                        Expanded(child: BluetoothManager().deviceList.length > 0 ?  ListView.separated(itemBuilder: (context,index){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BluetoothManager().deviceList[index].hasConected == true ?  Constants.customTextWidget(BluetoothManager().deviceList[index].device.name, 16, '#00ff00') : Constants.mediumGreyTextWidget(BluetoothManager().deviceList[index].device.name, 16),
                              Image(image: BluetoothManager().deviceList[index].hasConected == true  ? AssetImage('images/蓝牙连接图标.png') : AssetImage('images/蓝牙未连接图标.png'),width: 42,height: 18,)
                            ],
                          );
                        }, separatorBuilder: (context,index)=>SizedBox(height: 8,), itemCount: BluetoothManager().deviceListLength.value ) : EmptyView()),
                        SizedBox(height: 12,),
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 150,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Constants.customTextWidget('SCAN', 18, '#ff0000'),
                    ),
                  ),
                  SizedBox(height: 12,)
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
