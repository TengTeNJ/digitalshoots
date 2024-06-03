import 'package:robot/utils/string_util.dart';

class Gamemodel {
  String score = '0'; // 得分
  String speed = '0'; // 速度
  String indexString = '1';
  String createTime = ''; // 游戏时间
  String path = ''; // 游戏视频路径
  Gamemodel({required this.score, required this.indexString,this.speed = '0',this.path = ''});


  factory Gamemodel.modelFromJson(Map<String, dynamic> json) {
   Gamemodel model =  Gamemodel(
      score: json['score'] ?? '0',
     speed: json['speed'] ?? '0',
     indexString: json['indexString'] ?? '1',
     path: json['path'] ?? '',
   );
   model.createTime = json['createTime'] ??  StringUtil.currentTimeString();
   return model;
  }


  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'createTime': this.createTime,
        'score': this.score,
        'speed': this.speed,
        'indexString': this.indexString,
      };
}
