import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
class SystemUtil {
  /*锁定屏幕为竖屏*/
  static Future<void> lockScreenDirection() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

/*锁定屏幕为横屏幕*/
  static Future<void> lockScreenHorizontalDirection() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /*恢复屏幕可横竖屏切换*/
  static Future<void> resetScreenDirection() {
// 允许屏幕旋转
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
  }

  /*唤醒屏幕*/
  static wakeUpDevice(){
    WakelockPlus.enable();
  }

/*接触唤醒屏幕*/
  static disableWakeUpDevice(){
    WakelockPlus.disable();
  }

  /*判断是否是iPad*/
  static Future<bool> isIPad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    // 根据平台获取设备信息
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      // 这里可以通过 iosDeviceInfo.model 来判断是否为 iPad
      // 例如，检查 model 是否包含 "iPad" 字符串
      return iosDeviceInfo.model.toLowerCase().contains('ipad');
    } else {
      // 对于非 iOS 设备，可以返回 false 或者进行其他检查
      return false;
    }
  }


}
