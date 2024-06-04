import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_it/get_it.dart';
import 'package:robot/utils/ble_data.dart';
import '../constants/constants.dart';
import '../model/ble_model.dart';
import '../model/game_data.dart';
import 'ble_data_service.dart';
import 'global.dart';
import 'navigator_util.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
Timer? repeatTimer;
class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();

  factory BluetoothManager() {
    return _instance;
  }

  BluetoothManager._internal();

  final _ble = FlutterReactiveBle();

  // 蓝牙列表
  List<BLEModel> deviceList = [];

  // 已连接的蓝牙设备列表
  List<BLEModel>  get hasConnectedDeviceList  {
    return  this.deviceList.where((element) => element.hasConected == true).toList();
  }

  // 游戏数据
  GameData gameData = GameData();

  Function(BLEDataType type)? dataChange;
  Function(BLEDataType type)? deviceinfoChange; // 设备基本信息改变

  final ValueNotifier<int> deviceListLength = ValueNotifier(-1);

  // 已连接的设备数量
  final ValueNotifier<int> conectedDeviceCount = ValueNotifier(0);

  Stream<DiscoveredDevice>? _scanStream;

  int juniorRedIndex = -1; // junior模式 随机点亮的红灯的索引(3个target中随机选一个)
  int juniorBlueIndex = -1; // junior模式 随机点亮的蓝灯的索引(3个target中随机选一个)

  int battleRedIndex = -1; // battle模式 随机点亮的红灯target 非索引
  int battleBlueIndex = -1; // battle模式 随机点亮的蓝灯target 非索引
  List<int> battleTargetNumbers = [1,2,3,4,5,6]; // battle模式下 红蓝都支持1，2，3，4，5，6
  /*开始扫描*/
  Future<void> startScan() async {
    // 不能重复扫描
    if (_scanStream != null) {
      return;
    }
    if (Platform.isAndroid) {
      PermissionStatus locationPermission =
      await Permission.location.request();
      PermissionStatus bleScan =
      await Permission.bluetoothScan.request();
      PermissionStatus bleConnect =
      await Permission.bluetoothConnect.request();
      if (locationPermission == PermissionStatus.granted &&
          bleScan == PermissionStatus.granted &&
          bleConnect == PermissionStatus.granted) {
        _scanStream = _ble.scanForDevices(
          withServices: [],
          scanMode: ScanMode.lowLatency,
        );
        _scanStream!.listen((DiscoveredDevice event) {
          // 处理扫描到的蓝牙设备
          //print('event.name=${event.name}');
          if (kBLEDevice_Names.indexOf(event.name) != -1) {
            // 如果设备列表数组中无，则添加
            if (!hasDevice(event.id)) {
              this.deviceList.add(BLEModel(device: event));
              deviceListLength.value = this.deviceList.length;
              if(conectedDeviceCount.value <2){
                // 已经连接的设备少于两个 则自动连接
                conectToDevice(this.deviceList.last);
              }
            } else {
              // 设备列表数组中已有，则忽略
            }
          }
        });
      }
    } else {
      _scanStream = _ble.scanForDevices(
        withServices: [],
        scanMode: ScanMode.lowLatency,
      );
      _scanStream!.listen((DiscoveredDevice event) {
        // 处理扫描到的蓝牙设备
        // print('event.name=${event.name}');
        if (kBLEDevice_Names.indexOf(event.name) != -1) {
          // 如果设备列表数组中无，则添加
          if (!hasDevice(event.id)) {
            this.deviceList.add(BLEModel(device: event));
            deviceListLength.value = this.deviceList.length;
          } else {
            // 设备列表数组中已有，则忽略
          }
        }
      });
    }

  }

  /*连接设备*/
  conectToDevice(BLEModel model) {
    if (model.hasConected == true) {
      // 已连接状态直接返回
      return;
    }
    //EasyLoading.show();
    _ble
        .connectToDevice(
            id: model.device.id, connectionTimeout: Duration(seconds: 10))
        .listen((ConnectionStateUpdate connectionStateUpdate) {
      print('connectionStateUpdate = ${connectionStateUpdate.connectionState}');
      if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.connected) {
        // 连接设备数量+1
        conectedDeviceCount.value++;
        // 已连接
        model.hasConected = true;
        // 保存读写特征值
        final notifyCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse(kBLE_SERVICE_NOTIFY_UUID),
            characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_NOTIFY_UUID),
            deviceId: model.device.id);

        model.notifyCharacteristic = notifyCharacteristic;
        // 确保不是测速仪
        if(model.device.name != kBLEDevice_Name){
          final writerCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(kBLE_SERVICE_WRITER_UUID),
              characteristicId: Uuid.parse(kBLE_CHARACTERISTIC_WRITER_UUID),
              deviceId: model.device.id);
          model.writerCharacteristic = writerCharacteristic;
        }
        //  给digital shoots设备发送上线通知，不能给测速器发送
       if(model.device.name == kBLEDevice_NewName){
         writerDataToDevice(model, onLineData());
         // 每五秒发送一次心跳指令
         if(repeatTimer == null){
           repeatTimer = Timer.periodic(Duration(seconds: 5), (timer) {
             //print('这将每隔1秒执行一次');
             writerDataToDevice(model, heartBeatData());
             // 定时器执行完后的任务
             // 如果需要停止定时器，可以调用 timer.cancel()
           });
         }

       }
        // 连接成功弹窗
       //// EasyLoading.showSuccess('Bluetooth connection successful');
        // 监听数据
        _ble.subscribeToCharacteristic(notifyCharacteristic).listen((data) {
         // print("deviceId =${model.device.id}---上报来的数据data = $data");
          GameUtil gameUtil = GetIt.instance<GameUtil>();
          // 在游戏页面 才处理数据
          // if (gameUtil.nowISGamePage) {
          //   BluetoothDataParse.parseData(data);
          // }
          print('更新数据===${data}');
          BluetoothDataParse.parseData(data,model);
        });
      } else if (connectionStateUpdate.connectionState ==
          DeviceConnectionState.disconnected) {
   //     EasyLoading.showError('disconected');
        if(conectedDeviceCount.value > 0){
          conectedDeviceCount.value--;
        }
        // 失去连接
        model.hasConected = false;
        this.deviceList.remove(model);
        deviceListLength.value = this.deviceList.length;
      }
    });
  }

  /*发送数据*/
 Future<void> writerDataToDevice(BLEModel model, List<int> data) async {
    //  数据校验
    if (data == null || data.length == 0) {
      return;
    }
    // 确认蓝牙设备已连接 并保存对应的特征值
    if (model == null ||
        model.hasConected == null ||
        model.writerCharacteristic == null) {
      // TTToast.showErrorInfo('Please connect your device first');
      return;
    }
   return await _ble.writeCharacteristicWithoutResponse(model.writerCharacteristic!,
        value: data);
  }

  /*判断是否已经被添加设备列表*/
  bool hasDevice(String id) {
    Iterable<BLEModel> filteredDevice =
        this.deviceList.where((element) => element.device.id == id);
    return filteredDevice != null && filteredDevice.length > 0;
  }

  /*停止扫描*/
  stopScan() {
    //_scanStream = null;
  }

  triggerCallback({BLEDataType type = BLEDataType.none}) {
    dataChange?.call(type);
  }
  triggerDeviceInfoCallback({BLEDataType type = BLEDataType.dviceInfo}) {
    deviceinfoChange?.call(type);
  }

}
