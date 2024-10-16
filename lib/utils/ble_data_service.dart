/*响应数据的CMD*/

import 'dart:async';

import 'package:robot/utils/ble_send_util.dart';

import '../constants/constants.dart';
import '../model/ble_model.dart';
import 'blue_tooth_manager.dart';

enum BLEDataType {
  none,
  dviceInfo,
  boardBattery,
  targetResponse,
  score,
  gameStatu,
  remainTime,
  millisecond,
  targetIn,
  speed;
}
class ResponseCMDType {
  static const int deviceInfo = 0x20; // 设备信息，包含开机状态、电量等
  static const int speed = 0x25; // 速度
  static const int boardBattery = 0x24; // 从板电量上报

  static const int targetResponse = 0x26; // 标靶响应
  static const int score = 0x28; // 得分
  static const int gameStatu = 0x2A; // 游戏状态:开始和结束
  static const int remainTime = 0x2C; // 游戏剩余时长
  static const int millisecond = 0x32; // 游戏毫秒时间同步
  static const int targetIn = 0x10; // 目标击中
  static const int heartBeatQuery = 0x30; // 心跳查询
}

List<int> bleNotAllData = []; // 不完整数据 被分包发送的蓝牙数据
bool isNew = true;
Timer? delayTimer;

/*蓝牙数据解析类*/
class BluetoothDataParse {
  // 数据解析
  static parseData(List<int> data,BLEModel model) {
    if (data.isEmpty) {
      return;
    }
    if (data.length >= 2 && data[0] == kBLEDataFrameHeader) {
      // 取出来数据的长度标识位
      int length = data[1];
      // 通过 帧头 帧尾 length数据位的值和实际的数据包length进行匹配
      if (data.length >= length && data[length - 1] == kBLEDataFramerFoot) {
        List<int> rightData = data.sublist(0, length);
        handleData(rightData, model); // 完整的一帧数据
        List<int> othersData = data.sublist(length, data.length);
        isNew = true;
        bleNotAllData.clear();
        if (delayTimer != null) {
          delayTimer!.cancel();
        }
        if (!othersData.isEmpty) {
          parseData(othersData, model);
        }
      } else {
        handleNotFullData(data, model);
      }
    } else {
      handleNotFullData(data, model);
    }
  }

  static handleNotFullData(List<int> data, BLEModel model) {
    bleNotAllData.addAll(data);
    //print('handleNotFullData1${data.map((toElement) => toElement.toRadixString(16)).toList()}');
    //print('handleNotFullData12 ${isNew}');
    if (isNew) {
      isNew = false;
      delayTimer = Timer(Duration(milliseconds: 150), () {
        if (!isNew) {
          print(
              '解析数据超时 ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
          // print(Œ
          //     'bleNotAllData.toString()} == ${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}}');
          bleNotAllData.clear();
          isNew = true;
        }
      });
    } else {
      // print('handleNotFullData3${bleNotAllData.map((toElement) => toElement.toRadixString(16)).toList()}');
      if (bleNotAllData.length >= 4 &&
          bleNotAllData[0] == kBLEDataFrameHeader) {
        int length = bleNotAllData[3];
        if (bleNotAllData.length >= length &&
            bleNotAllData[length - 1] == kBLEDataFramerFoot) {
          List<int> rightData = bleNotAllData.sublist(0, length);
          handleData(rightData, model); // 完整的一帧数据
          List<int> othersData =
          bleNotAllData.sublist(length, bleNotAllData.length);
          isNew = true;
          bleNotAllData.clear();
          if (delayTimer != null) {
            delayTimer!.cancel();
          }
          if (!othersData.isEmpty) {
            parseData(othersData, model);
          }
        }
      }
    }
  }

  static handleData(List<int> element,BLEModel mode){
    if (element.length < 4) {
      // print('解析数据出错');
      return;
    }
    // 去除帧头
    element = element.sublist(1, element.length);
    int cmd = element[1];
    switch (cmd) {
      case ResponseCMDType.deviceInfo:
        int parameter_data = element[2];
        int statu_data = element[3];
        if (parameter_data == 0x01) {
          // 开关机
         BluetoothManager().gameData.powerOn = (statu_data == 0x01);
        } else if (parameter_data == 0x02) {
          // 电量
          BluetoothManager().gameData.powerValue = statu_data;
          BluetoothManager().triggerDeviceInfoCallback (type: BLEDataType.dviceInfo);
          print('电量---${statu_data}');
        }
        break;
      case ResponseCMDType.boardBattery:
        int board_index = element[2];
        int online_status = element[3];
        int battery = element[4];
        if (board_index == 1) {
          BluetoothManager().gameData.firstPower = battery;
        } else if (board_index == 2) {
          BluetoothManager().gameData.secondPower = battery;
        } else if (board_index == 3) {
          BluetoothManager().gameData.thirdPower = battery;
        }  else if (board_index == 4) {
          BluetoothManager().gameData.fourPower = battery;
        }  else if (board_index == 5) {
          BluetoothManager().gameData.fivePower = battery;
        }  else if (board_index == 6) {
          BluetoothManager().gameData.sixPower = battery;
        }
        BluetoothManager().triggerDeviceInfoCallback(type: BLEDataType.boardBattery);
        print('从板board_index---${board_index}');
        print('从板online_status---${online_status}');
        print('从板battery---${battery}');
        case ResponseCMDType.targetResponse:
        int data = element[2];
       // print('------data=${element}');
        String binaryString = data.toRadixString(2); // 转换成二进制字符串
        if (binaryString != null && binaryString.length == 8) {
          // 前两位都是1，不区分红灯和蓝灯，截取后边6位，判断哪个灯在亮
          final sub_string = binaryString.substring(2, 8);
          //print('sub_string=${sub_string}');
          final ligh_index = sub_string.indexOf('1');
          final actual_index = 5 - ligh_index + 1;
          print('号灯亮了');
          // print('binaryString=${binaryString}');
          BluetoothManager().triggerCallback(type: BLEDataType.targetResponse);
        }
        break;
      case ResponseCMDType.score:
        int data = element[2];
        BluetoothManager().gameData.score = data;
        // 通知
        print(
            'BluetoothManager().dataChange=${BluetoothManager().dataChange}');
        BluetoothManager().triggerCallback(type: BLEDataType.score);
        // print('${data}:得分');
        break;
      case ResponseCMDType.gameStatu:
        int data = element[2];
        BluetoothManager().gameData.gameStart = (data == 0x01);
        // print('游戏状态---${data}');
        BluetoothManager().triggerCallback(type: BLEDataType.gameStatu);
        break;
      case ResponseCMDType.remainTime:
        int data = element[2];
        BluetoothManager().gameData.remainTime = data;
        BluetoothManager().triggerCallback(type: BLEDataType.remainTime);
        break;
      case ResponseCMDType.millisecond:
        int data = element[2];
        BluetoothManager().gameData.millSecond = data;
        //  print('毫秒刷新---${data}');
        BluetoothManager().triggerCallback(type: BLEDataType.millisecond);
        break;
      case ResponseCMDType.speed:
        int data = element[2];
        BluetoothManager().gameData.speed = data;
        print('速度---${data}');
        BluetoothManager().triggerCallback(type: BLEDataType.speed);

        break;
      case ResponseCMDType.targetIn:
        // mcu主动上报击中
        int data = element[2];
        BluetoothManager().gameData.targetNumber = data;
        BluetoothManager().triggerCallback(type: BLEDataType.targetIn);
        print('mcu主动上报击中--${data}');
        break;
      case ResponseCMDType.heartBeatQuery:
        // 收到心跳查询连续不响应 会导致游戏异常 比如任意集中标靶 收不到响应
        BLESendUtil.heartBeatResponse();
        break;
    }
  }
}

/*数据拆分*/
List<List<int>> splitData(List<int> _data) {
  int a = kBLEDataFrameHeader;
  List<List<int>> result = [];
  int start = 0;
  while (true) {
    int index = _data.indexOf(a, start);
    if (index == -1) break;
    List<int> subList = _data.sublist(start, index);
    result.add(subList);
    start = index + 1;
  }
  if (start < _data.length) {
    List<int> subList = _data.sublist(start);
    result.add(subList);
  }
  return result;
}
