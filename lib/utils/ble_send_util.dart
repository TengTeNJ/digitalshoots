import 'dart:async';
import 'dart:math';
import 'package:robot/model/ble_model.dart';

import '../constants/constants.dart';
import 'ble_data.dart';
import 'blue_tooth_manager.dart';
import 'package:synchronized/synchronized.dart';

class BLESendUtil {
  // heartBeatResponseData
  /*心跳相应*/
  static heartBeatResponse() {
    BluetoothManager()
        .writerDataToDevice(getWriterDevice(), heartBeatResponseData());
  }

  /*打开所有蓝灯*/
  static Future<void> openAllBlueLight() async {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    await closeAllLight(); // 先关闭所有的灯 再打开。防止红蓝同时打开
    return await BluetoothManager()
        .writerDataToDevice(getWriterDevice(), openAllBlueLightData());
  }

  /*关闭所有蓝色灯光*/
  static Future<void> closeAllBlueLight() async {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    return await BluetoothManager()
        .writerDataToDevice(getWriterDevice(), closeAllBlueLightData());
  }

  /*关闭所有红色灯光*/
  static Future<void> closeAllRedLight() async {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    return await BluetoothManager().writerDataToDevice(
        BluetoothManager().hasConnectedDeviceList[0], closeAllRedLightData());
  }

  /*关闭所有灯光*/
  static Future<void> closeAllLight() async {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    return await BluetoothManager()
        .writerDataToDevice(getWriterDevice(), closeAllLightData());
  }

  static preGame(int number) {
    BluetoothManager()
        .writerDataToDevice(getWriterDevice(), preGameData(number));
  }

  // showGoData
  static showGo(int number) {
    BluetoothManager().writerDataToDevice(getWriterDevice(), showGoData());
  }

/*关闭蓝灯*/
  static Future<void> closeBlueLights(List<int> targets) async {
    return await BluetoothManager()
        .writerDataToDevice(getWriterDevice(), closeBlueLightsData(targets));
  }

  /*打开紫灯*/
  static Future<void> openPurpleLights(int number) async {
    return await BluetoothManager()
        .writerDataToDevice(getWriterDevice(), openPurpleLightsData(number));
  }

/*关闭紫灯*/
  static Future<void> closePurpleLights(int number) async {
    return await BluetoothManager()
        .writerDataToDevice(getWriterDevice(), closePurpleLightsData(number));
  }

  // static Future<void> closeLights(int number) async {
  //   return await BluetoothManager()
  //       .writerDataToDevice(getWriterDevice(), closeLightsData(number));
  // }


  // noviceShakeData
  static noviceShake() {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), noviceShakeData());
  }

  static juniorShake() {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), noviceShakeData());
  }

  // 退出APP模式
  static appOffLine() {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    BluetoothManager().writerDataToDevice(getWriterDevice(), offLineData());
  }


  /*Junior 模式的每次灯光控制*/
  static juniorControlLight() {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
   // closeAllLightData(); // 先关闭所有灯光
   Future.delayed(Duration(milliseconds: 200),(){
     int _blueIndex = BluetoothManager().juniorBlueIndex;
     int _redIndex = BluetoothManager().juniorRedIndex;
     if (_blueIndex == -1 || _redIndex == -1) {
       // 说明游戏刚开始 先随机取出来一个随机数
       int red_index = Random().nextInt(3);
       int blue_index = Random().nextInt(3);
       BluetoothManager().juniorBlueIndex = blue_index;
       BluetoothManager().juniorRedIndex = red_index;
       BluetoothManager().writerDataToDevice(getWriterDevice(),
           openJuniorBlueLightData(kJuniorBluetargets[blue_index]));
       BluetoothManager().writerDataToDevice(getWriterDevice(),
           openJuniorRedLightData(kJuniorRedtargets[red_index]));
     } else {
       // 说明不是第一次取随机数 所以先判断取出来的和上次一样不,一样的话就重新取
       int red_index;
       int blue_index;
       do {
         red_index = Random().nextInt(3);
       } while (BluetoothManager().juniorRedIndex == red_index);
       BluetoothManager().juniorRedIndex = red_index;

       do {
         blue_index = Random().nextInt(3);
       } while (BluetoothManager().juniorBlueIndex == blue_index);
       BluetoothManager().juniorBlueIndex = blue_index;

       BluetoothManager().writerDataToDevice(getWriterDevice(),
           openJuniorBlueLightData(kJuniorBluetargets[blue_index]));
     Future.delayed(Duration(milliseconds: 200),(){
       BluetoothManager().writerDataToDevice(getWriterDevice(),
           openJuniorRedLightData(kJuniorRedtargets[red_index]));
     });
     }
   });
  }

  static BLEModel getWriterDevice() {
    final model = BluetoothManager()
        .hasConnectedDeviceList
        .firstWhere((element) => element.notifyCharacteristic != null);
    return model;
  }

  /*battle模式下控制红灯*/
  static Future<void> battleControlRedLight() async {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    // 先关闭所有红灯
    await closeAllRedLight();
    // 获取当前红灯target
    final Lock lock = Lock();
    await lock.synchronized(() async {
      int redLightIndex = BluetoothManager().battleRedIndex;
      print(
          '红色BluetoothManager().battleTargetNumbers=${BluetoothManager().battleTargetNumbers}');
      if (BluetoothManager().battleTargetNumbers.isEmpty) {
        // target数组为空的话则代表循环了一轮 重新添加
        BluetoothManager().battleTargetNumbers.addAll([1, 2, 3, 4, 5, 6]);
      }
      List<int> battleTargets = BluetoothManager().battleTargetNumbers;
      int red_index;
      do {
        red_index = Random().nextInt(battleTargets.length);
      } while (redLightIndex == battleTargets[red_index]);
      BluetoothManager().battleRedIndex = battleTargets[red_index];
      await BluetoothManager().writerDataToDevice(
          getWriterDevice(), openJuniorRedLightData(battleTargets[red_index]));
      BluetoothManager().battleTargetNumbers.remove(battleTargets[red_index]);
    });
  }

  /*battle模式下控制蓝灯*/
  static Future<void> battleControlBlueLight() async {
    if (BluetoothManager().hasConnectedDeviceList.isEmpty) {
      return;
    }
    // 先关闭所有蓝灯
    await closeAllBlueLight();
    final Lock lock = Lock();
    await lock.synchronized(() async {
      // 获取当前蓝灯target
      int redLightIndex = BluetoothManager().battleBlueIndex;
      print(
          '蓝灯BluetoothManager().battleTargetNumbers=${BluetoothManager().battleTargetNumbers}');
      if (BluetoothManager().battleTargetNumbers.isEmpty) {
        // target数组为空的话则代表循环了一轮 重新添加
        BluetoothManager().battleTargetNumbers.addAll([1, 2, 3, 4, 5, 6]);
      }
      List<int> battleTargets = BluetoothManager().battleTargetNumbers;
      int blue_index;
      do {
        blue_index = Random().nextInt(battleTargets.length);
      } while (redLightIndex == battleTargets[blue_index]);
      BluetoothManager().battleBlueIndex = battleTargets[blue_index];
      await BluetoothManager().writerDataToDevice(getWriterDevice(),
          openJuniorBlueLightData(battleTargets[blue_index]));
      BluetoothManager().battleTargetNumbers.remove(battleTargets[blue_index]);
    });
  }

  /*蓝灯闪烁效果*/
  static Future<dynamic> blueLightBlink() async {
    final List<Future<dynamic>> futures = [];
    futures.add(closeAllLight());
    futures.add(Future.delayed(Duration(milliseconds: 500), () async {
      print('1-----');
      await openAllBlueLight();
    }));
    futures.add(Future.delayed(Duration(milliseconds: 1000), () async {
      print('2-----');
      await closeAllLight();
    }));
    futures.add(Future.delayed(Duration(milliseconds: 1500), () async {
      print('3-----');
      await openAllBlueLight();
    }));
    futures.add(Future.delayed(Duration(milliseconds: 2000), () async {
      print('4-----');
      await closeAllLight();
    }));
    return await Future.wait(futures);
  }
}
