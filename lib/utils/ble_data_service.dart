/*响应数据的CMD*/

import 'package:robot/utils/ble_send_util.dart';

import '../constants/constants.dart';
import '../model/ble_model.dart';
import 'blue_tooth_manager.dart';

enum BLEDataType {
  none,
  dviceInfo,
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
/*蓝牙数据解析类*/
class BluetoothDataParse {
  // 数据解析
  static parseData(List<int> data,BLEModel model) {
    if (data.contains(kBLEDataFrameHeader)) {
      List<List<int>> _datas = splitData(data);
      _datas.forEach((element) {
        if (element == null || element.length == 0) {
          // 空数组
         // print('问题数据${element}');
        } else {
          // 先获取长度
          int length = element[0] - 1; // 获取长度 去掉了枕头
          if(length != element.length ){
            // 说明不是完整数据
            bleNotAllData.addAll(element);
            if(bleNotAllData[0] - 1 == bleNotAllData.length){
              print('组包1----${element}');
              handleData(bleNotAllData);
              isNew = true;
              bleNotAllData.clear();
            }else{
              isNew = false;
              Future.delayed(Duration(milliseconds: 10),(){
                if(!isNew){
                  bleNotAllData.clear();
                }
              });
            }
          }else{
            handleData(element);
          }

        }
      });
    } else {
      print('model.device.name=${model.device.name}');
      if(model.device.name == kBLEDevice_Name){
        // 如果是测速仪器
        int speed = data[0];
        BluetoothManager().gameData.speed = speed;
        BluetoothManager().triggerCallback(type: BLEDataType.speed);
        print('-------');
        return;
      }
        bleNotAllData.addAll(data);
        if(bleNotAllData[0] - 1 == bleNotAllData.length){
          print('组包2----${data}');
          handleData(bleNotAllData);
          isNew = true;
          bleNotAllData.clear();
        }else{
          isNew = false;
          Future.delayed(Duration(milliseconds: 10),(){
            if(!isNew){
              bleNotAllData.clear();
            }
          });
        }
      print('蓝牙设备响应数据不合法=${data}');
    }
  }
  static handleData(List<int> element){
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
        }
        break;
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
