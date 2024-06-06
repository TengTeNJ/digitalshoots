import 'dart:async';

import 'package:robot/constants/constants.dart';
import 'package:robot/utils/notification_bloc.dart';

class Countdown75Timer {
  int _minutes = 1;
  int _seconds = 15;
  Timer? _timer;

  // 回调函数，用于更新UI
  Function()? onTick;

  Countdown75Timer({Function()? onTick}) : this.onTick = onTick;

  void start() {
    print('---start---');
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      decrementSeconds();
      if (onTick != null) {
        onTick!(); // 调用回调函数，触发UI更新
      }
    });
  }

  void decrementSeconds() {
    _seconds -- ;
    if (_seconds < 0) {
      _seconds = 59;
      _minutes--;
    }
    if(_seconds == 0 && _minutes == 0){
      // 一轮倒计时结束
      stop();
      EventBus().sendEvent(kJuniorGameEnd);
    }
  }

  void stop() {
    _timer?.cancel();
    _minutes = 1;
    _seconds = 15;
  }

  void dispose() {
    _timer?.cancel();
  }

  String get formattedTime => '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}';
}