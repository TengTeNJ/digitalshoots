import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/route/route.dart';
import 'package:robot/utils/game_data_util.dart';
import '../../constants/constants.dart';
import '../../utils/ble_data_service.dart';
import '../../utils/blue_tooth_manager.dart';
import '../../utils/global.dart';
import '../../utils/navigator_util.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  bool? showBack;

  CustomAppBar({
    this.title = '',
    this.showBack = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(Constants.navigationBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  int batteryLevel = 100; // 电池电量等级
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BluetoothManager().deviceinfoChange = (BLEDataType type) async {
      if (type == BLEDataType.dviceInfo) {
        // 电池电量改变
        batteryLevel = GameDataUtil.powerValueToBatteryImageLevel(
            BluetoothManager().gameData.powerValue);
        if (mounted) {
          setState(() {});
        }
      }
    };
    BluetoothManager().conectedDeviceCount.addListener(() {
      // 连接状态改变
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 115,
      //  leadingWidth会影响title的位置
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          if (gameUtil.pageDepth == 0) {
            NavigatorUtil.push(Routes.blelist);
          }
        },
        child: Row(
          children: [
            SizedBox(
              width: 6,
            ),
            Image(
              image: AssetImage(BluetoothManager().conectedDeviceCount.value > 0
                  ? 'images/蓝牙图标-蓝色.png'
                  : 'images/蓝牙图标-灰色.png'),
              height: 10,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              BluetoothManager().conectedDeviceCount.value > 0
                  ? 'Connected'
                  : 'Disconnected',
              style: TextStyle(
                  fontSize: 10,
                  color: BluetoothManager().conectedDeviceCount.value > 0
                      ? Colors.blue
                      : Constants.baseGreyStyleColor),
            )
          ],
        ),
      ),
      actions: [
        BluetoothManager().conectedDeviceCount.value > 0
            ? Image(
                image: AssetImage('images/battery/${batteryLevel}.png'),
                width: 37,
                height: 18.5,
              )
            : Container()
      ],
      title: Image(
        image: AssetImage('images/topLogo.png'),
        height: 20,
        fit: BoxFit.fitHeight,
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
    );
  }
}
