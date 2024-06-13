import 'dart:io';
import 'package:robot/constants/constants.dart';
import 'package:robot/model/game_model.dart';
import 'package:robot/utils/data_base.dart';
import 'package:robot/utils/string_util.dart';

class LocalDataUtil {
  /*获取历史最高分*/
  static Future<Gamemodel> getHistoryMaxScore() async {
    final _list = await DatabaseHelper().getData(kDataBaseTableName);
    if (_list.isEmpty) {
      return Gamemodel(score: '0', indexString: '1');
    } else {
      _list.sort((a, b) {
        // 假设score属性是字符串，需要转换为int类型
        int scoreA = int.parse(a.score);
        int scoreB = int.parse(b.score);
        return scoreB.compareTo(scoreA);
      });
      return _list.first;
    }
  }

  /*获取历史成绩最好的10条数据 只需要今天的*/
  static Future<List<Gamemodel>> getHistoryBestTenDatas() async {
    String _currentTimeString = StringUtil.currentTimeString(); // 获取当前的时间字符串
    _currentTimeString = _currentTimeString.substring(0, 8); // 截取仅仅需要到年月日
    // 把最近的数据靠前展示 先顺序反转
    List<Gamemodel> _list = await DatabaseHelper().getData(kDataBaseTableName);
    _list = List.generate(
      _list.length,
      (index) => _list[_list.length - 1 - index],
    );
    // 只需要今天的数据
    _list = _list.where((element) {
      String elementTime = element.createTime;
      if (elementTime.length > 8) {
        elementTime = elementTime.substring(0, 8);
      }
      return _currentTimeString == elementTime;
    }).toList();

    if (_list.length < 10) {
      _list.forEach((element) {
        element.indexString = (_list.indexOf(element) + 1).toString();
      });
      return _list;
    } else {
      // 如果数据超过10条 就进行score排序
      _list.sort((a, b) {
        int scoreA = int.parse(a.score);
        int scoreB = int.parse(b.score);
        return scoreB.compareTo(scoreA);
      });
      // 然后取出来前10条
      final _bestList = _list.sublist(0, 10);
      // 然后按照时间的顺序进行排列
      _bestList.sort((a, b) {
        return StringUtil.compareTimeString(a.createTime, b.createTime);
      });
      _bestList.forEach((element) {
        element.indexString = (_bestList.indexOf(element) + 1).toString();
      });
      return _bestList;
    }

    return _list;
  }

/*获取最近的一条数据*/
  static Future<Gamemodel> getRecentData() async {
    final _list = await DatabaseHelper().getData(kDataBaseTableName);
    if (_list.isEmpty) {
      Gamemodel model = Gamemodel(score: '-', indexString: '1');
      model.speed = '-';
      return model;
    } else {
      return _list.last;
    }
  }

  /*视频超过最大数量后 主动删除非最大score数据的视频*/
  static Future<void> getDeletedVideoPath() async {
    List<Gamemodel> videoDatas = [];
    List<Gamemodel> tempDatas = [];
    final _list = await DatabaseHelper().getData(kDataBaseTableName);
    videoDatas = _list.where((element) => element.path.length > 0).toList();
    int count = videoDatas.length; // 视频数据的数量
    if (count > Constants.kMaxVideoCount) {
      // 有视频数据的最遥远的一条数据
      Gamemodel model = videoDatas.first;
      // 获取历史最高分
      Gamemodel bestDataModel = await getHistoryMaxScore();
      if (model.createTime != bestDataModel.createTime) {
        // 有视频的最遥远的一条数据如果不是历史最好成绩，就删除这条视频
        final file = File(model.path);
        if (file.existsSync()) {
          print('删除文件---${model.path}');
          file.deleteSync();
          model.path = '';
          DatabaseHelper().updateData(
              kDataBaseTableName, model.toJson(), int.parse(model.id));
        }
      } else {
        // 删除 倒数第二条
        if (videoDatas.length > 1) {
          Gamemodel model = videoDatas[1];
          final file = File(model.path);
          if (file.existsSync()) {
            print('删除文件---${model.path}');
            file.deleteSync();
            model.path = '';
            DatabaseHelper().updateData(
                kDataBaseTableName, model.toJson(), int.parse(model.id));
          }
        }
      }
    } else {
      print('不需要删除视频数据');
    }
  }
}
