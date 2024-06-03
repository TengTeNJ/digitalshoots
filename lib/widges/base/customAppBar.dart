
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robot/route/route.dart';
import '../../constants/constants.dart';
import '../../utils/blue_tooth_manager.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BluetoothManager().conectedDeviceCount.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 115, //  leadingWidth会影响title的位置
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          NavigatorUtil.push(Routes.blelist);
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
        Image(image: AssetImage('images/battery/100.png'),width: 37,height: 18.5,)
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
