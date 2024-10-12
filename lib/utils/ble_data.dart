/*APP上线*/
List<int> onLineData() {
  int v = 0xA5 + 0x07 + 0x22 + 0x01 + 0x01;
  List<int> values = [0xA5, 0x07, 0x22, 0x01, 0x01, v, 0xAA];
  print('APP上线=${values}');
  return values;
}
/*APP下线*/
List<int> offLineData() {
  int v = 0xA5 + 0x06 + 0x16 + 0x00;
  List<int> values = [0xA5, 0x06, 0x16, 0x00, v, 0xAA];
  print('APP下线=${values}');
  return values;
}

/*心跳*/
List<int> heartBeatData() {
  int v = 0xA5 + 0x05 + 0x30;
  List<int> values = [0xA5, 0x05, 0x30, v, 0xAA];
  //print('关闭蓝灯:${values}');
  return values;
}

/*心跳响应*/
List<int> heartBeatResponseData() {
  int v = 0xA5 + 0x05 + 0x31;
  List<int> values = [0xA5, 0x05, 0x31, v, 0xAA];
  // print('心跳响应:${values}');
  return values;
}

/*打开所有蓝灯*/
List<int> openAllBlueLightData() {
  // 0xbf = 10111111
  int v = 0xA5 + 0x06 + 0x01 + 0xbf;
  List<int> values = [0xA5, 0x06, 0x01, 0xbf, v, 0xAA];
  // print('打开所有蓝灯:${values}');
  return values;
}

/*关闭所有蓝灯*/
List<int> closeAllBlueLightData() {
  // 0x80 = 10000000
  int v = 0xA5 + 0x06 + 0x01 + 0x80;
  List<int> values = [0xA5, 0x06, 0x01, 0x80, v, 0xAA];
  // print('关闭所有蓝灯:${values}');
  return values;
}

List<int> closeAllRedLightData() {
  // 0x40 = 01000000
  int v = 0xA5 + 0x06 + 0x01 + 0x40;
  List<int> values = [0xA5, 0x06, 0x01, 0x40, v, 0xAA];
  // print('关闭所有蓝灯:${values}');
  return values;
}

/*关闭所有灯光*/
List<int> closeAllLightData() {
  // 0xc0 = 11000000
  int v = 0xA5 + 0x06 + 0x01 + 0xc0;
  List<int> values = [0xA5, 0x06, 0x01, 0xc0, v, 0xAA];
  //print('关闭所有灯光(红 + 蓝):${values}');
  return values;
}

/*
3，2，1倒计时数码管显示
* */
List<int> preGameData(int number) {
  // 0xc0 = 11000000
  int v = 0xA5 + 0x08 + 0x09 + 0x30 + 0x30 + (0x30 + number);
  List<int> values = [0xA5, 0x08, 0x09, 0x30, 0x30, (0x30 + number), v, 0xAA];
  //print('3 2 1倒计时显示:${values}');
  return values;
}

/*数码管显示GO*/
List<int> showGoData() {
  // 0xc0 = 11000000
  int v = 0xA5 + 0x08 + 0x09 + 0x00 + 0x47 + 0x4f;
  List<int> values = [0xA5, 0x08, 0x09, 0x00, 0x47, 0x4f, v, 0xAA];
//  print('数码管得分显示GO:${values}');
  return values;
}

/*
* 数码管显示得分*/
List<int> showScoreGameData(int number) {
  int one = (number / 100).toInt();
  int two = ((number / 10).toInt()) % 10;
  int three = number % 10;
  // 0xc0 = 11000000
  int v = 0xA5 + 0x08 + 0x09 + (0x30 + one) + (0x30 + two) + (0x30 + three);
  List<int> values = [
    0xA5,
    0x08,
    0x09,
    (0x30 + one),
    (0x30 + two),
    (0x30 + three),
    v,
    0xAA
  ];
  print('数码管得分显示:${values}');
  return values;
}

/*关闭蓝灯,批次传入,targets为索引，比如1号灯，就传0*/
List<int> closeBlueLightsData(List<int> targets) {
  String pre_data = '10';
  targets = targets.map((e) => (e - 5).abs()).toList();
  for (int i = 0; i < 6; i++) {
    if (targets.contains(i)) {
      // 关闭
      pre_data += '0';
    } else {
      // 打开
      pre_data += '1';
    }
  }
  // 二进制字符串转换为10进制
  int data = int.parse(pre_data, radix: 2);
  int v = 0xA5 + 0x06 + 0x01 + data;
  List<int> values = [0xA5, 0x06, 0x01, data, v, 0xAA];
  //print('关闭蓝灯:${values}');
  return values;
}

// 打开紫灯
List<int> openPurpleLightsData(int targetNumber) {
  String pre_data = '11';
  List<int> values = [0, 0, 0, 0, 0, 0];
  int targetIndex = (targetNumber - 1 - 5).abs();
  values[targetIndex] = 1;
  values.forEach((element) {
    pre_data += element.toString();
  });
  int data = int.parse(pre_data, radix: 2);
  print('打开紫灯${data}');
  //  开灯
  int v = 0xA5 + 0x07 + 0x27 + 0x01 + targetNumber;
  List<int> targetDatas = [0xA5, 0x07, 0x27,0x01, targetNumber ,v ,0xAA];
  print('打开某个紫灯:${pre_data}');
  return targetDatas;
}
// 关闭紫灯
List<int> closePurpleLightsData(int targetNumber) {
  String pre_data = '11';
  List<int> values = [0, 0, 0, 0, 0, 0];
  int targetIndex = (targetNumber - 1 - 5).abs();
  values[targetIndex] = 1;
  values.forEach((element) {
    pre_data += element.toString();
  });
  int data = int.parse(pre_data, radix: 2);
  print('关闭紫灯${data}');
  // 0x00 关灯
  int v = 0xA5 + 0x07 + 0x27 + 0x00 + targetNumber;
  List<int> targetDatas = [0xA5, 0x07, 0x27,0x00, targetNumber ,v ,0xAA];
  print('关闭某个紫灯:${pre_data}');
  return targetDatas;
}

/*Junior模式打开某个蓝灯*/
List<int> openJuniorBlueLightData(int targetNumber) {
  String pre_data = '10';
  List<int> values = [0, 0, 0, 0, 0, 0];
  int targetIndex = (targetNumber - 1 - 5).abs();
  values[targetIndex] = 1;
  values.forEach((element) {
    pre_data += element.toString();
  });
  int data = int.parse(pre_data, radix: 2);
  int v = 0xA5 + 0x06 + 0x01 + data;
  List<int> targetDatas = [0xA5, 0x06, 0x01, data, v, 0xAA];
  print('junior模式仅仅打开某个蓝灯:${pre_data}');
  return targetDatas;
}

/*Junior模式打开某个红灯*/
List<int> openJuniorRedLightData(int targetNumber) {
  String pre_data = '01';
  List<int> values = [0, 0, 0, 0, 0, 0];
  int targetIndex = (targetNumber - 1 - 5).abs();
  values[targetIndex] = 1;
  values.forEach((element) {
    pre_data += element.toString();
  });
  int data = int.parse(pre_data, radix: 2);
  int v = 0xA5 + 0x06 + 0x01 + data;
  List<int> targetDatas = [0xA5, 0x06, 0x01, data, v, 0xAA];
  print('junior模式仅仅打开某个红灯:${pre_data}');
  return targetDatas;
}

/*打开设备秒表倒计时效果*/
List<int> milleEnableData() {
  int v = 0xA5 + 0x06 + 0x34 + 0x01;
  List<int> values = [0xA5, 0x06, 0x34, 0x01, v, 0xAA];
  return values;
}

List<int> noviceShakeData() {
  int v = 0xA5 + 0x06 + 0x05 + 0x0A;
  List<int> values = [0xA5, 0x06, 0x05, 0x0A, v, 0xAA];
  return values;
}

List<int> juniorShakeData() {
  int v = 0xA5 + 0x06 + 0x05 + 0x1E;
  List<int> values = [0xA5, 0x06, 0x05, 0x1E, v, 0xAA];
  return values;
}
