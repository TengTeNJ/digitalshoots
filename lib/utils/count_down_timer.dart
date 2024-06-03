import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer {
  int _minutes = 0;
  int _seconds = 0;
  int _milliseconds = 0;
  Timer? _timer;

  // 回调函数，用于更新UI
  Function()? onTick;

  CountdownTimer({Function()? onTick}) : this.onTick = onTick;

  void start() {
    print('---start---');
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_milliseconds < 100) {
        _milliseconds += 1;
      } else {
        _milliseconds = 0;
        incrementSeconds();
      }
      print('-----');
      if (onTick != null) {
        print('---onclick---');
        onTick!(); // 调用回调函数，触发UI更新
      }
    });
  }

  void incrementSeconds() {
    if (_seconds < 59) {
      _seconds++;
    } else {
      _seconds = 0;
      incrementMinutes();
    }
  }

  void incrementMinutes() {
    if (_minutes < 59) {
      _minutes++;
    } else {
      // 处理分钟超过59的情况，例如重置或停止倒计时
    }
  }

  void stop() {
    _timer?.cancel();
    _minutes = 0;
    _seconds = 0;
    _milliseconds = 0;
  }

  void dispose() {
    _timer?.cancel();
  }

  String get formattedTime => '${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}:${_milliseconds.toString().padLeft(3, '0')}';
}