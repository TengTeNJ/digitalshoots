import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color.dart';

class Constants {
  //  屏幕宽度
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  //  屏幕高度
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // 状态栏高度
  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // 底部导航栏的高度，一般时动态获取的
  static Future<double> bottomBarHeight(BuildContext context) async {
    return MediaQuery.of(context).padding.bottom;
  }

  // 用于表示工具栏的默认高度，在Material Design中通常为56像素。工具栏用于显示应用程序的标题、操作按钮等内容。
  static double appBarHeight = kToolbarHeight;

  // 底部导航栏高度 默认为56像素
  static double tabBarHeight = kBottomNavigationBarHeight;

  static int kMaxVideoCount = 20; // 本地存储的视频的最大数量

 // 导航栏的高度
  static double navigationBarHeight = 44;

  static String privacyText =
      'To ensure that personal information of players are respected and protected.  I give explicit authorization and consent for their use in commercial promotion or publication on social media. Such materials can only be legally used after obtaining explicit written consent.';

  static Color darkThemeColor = Color.fromRGBO(38, 38, 48, 1);
  static Color darkThemeOpacityColor = Color.fromRGBO(41, 41, 54, 0.24);
  static Color baseStyleColor = Color.fromRGBO(248, 133, 11, 1);
  static Color baseGreyStyleColor = Color.fromRGBO(177, 177, 177, 1);
  static Color darkControllerColor = Color.fromRGBO(57, 57, 75, 1);
  static Color baseControllerColor = Color.fromRGBO(41, 41, 54, 1);
  static Color geryBGColor = Color.fromRGBO(247, 242, 244, 1);
  static Color baseGreenStyleColor = Color.fromRGBO(116, 193, 165, 1);

  static Text regularBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  static Text regularGreyTextWidget(String text, double fontSize,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Constants.baseGreyStyleColor,
          fontSize: fontSize),
    );
  }

  static Text regularWhiteTextWidget(String text, double fontSize,
      {int? maxLines,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: fontSize),
    );
  }

  static Text boldWhiteItalicTextWidget(String text, double fontSize,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      maxLines: maxLines ?? null,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontStyle: FontStyle.italic, // 设置字体为斜体
          fontSize: fontSize),
    );
  }

  // Italic
  static Text mediumBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  static Text mediumGreyTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Constants.baseGreyStyleColor,
          fontSize: fontSize),
    );
  }

  static Text mediumWhiteTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      maxLines: maxLines,
      textAlign: textAlign,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: fontSize),
    );
  }

  static Text boldWhiteTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
        height: height,
        fontFamily: 'SanFranciscoDisplay',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }
/*斜体黑色*/
  static Text boldBlackItalicTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(28, 30, 33, 1.0),
          fontStyle: FontStyle.italic, // 设置字体为斜体
          fontSize: fontSize),
    );
  }

  static Text boldBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'SanFranciscoDisplay4',
          fontWeight: FontWeight.bold,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  // DS-DIGI
  static Text digiRegularWhiteTextWidget(String text, double fontSize,
      {int maxLines = 1,
      TextAlign textAlign = TextAlign.center,
      double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'DS-DIGI',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: fontSize),
    );
  }

  static Text digiRegularBaseTextWidget(String text, double fontSize,
      {int maxLines = 1,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines,
      text,
      style: TextStyle(
          height: height,
          fontFamily: 'DS-DIGI',
          fontWeight: FontWeight.w400,
          color: Constants.baseStyleColor,
          fontSize: fontSize),
    );
  }

  static Text customTextWidget(String text, double fontSize, String color,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0,
        TextOverflow? overflow}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines ?? null,
      text,
      style: TextStyle(
          overflow: overflow,
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: FontWeight.bold,
          color: hexStringToColor(color),
          fontSize: fontSize),
    );
  }
  static TextStyle placeHolderStyle() {
    return TextStyle(
        color: Color.fromRGBO(132, 132, 132, 1.0),
        fontFamily: 'SemiBold',
        fontSize: 16,
        fontWeight: FontWeight.w600);
  }

  static Text customItalicTextWidget(String text, double fontSize, Color color,
      {int? maxLines,
        TextAlign textAlign = TextAlign.center,
        double height = 1.0,
        FontWeight? fontWeight,
        TextOverflow? overflow}) {
    return Text(
      textAlign: textAlign,
      maxLines: maxLines ?? null,
      text,
      style: TextStyle(
          overflow: overflow,
          height: height,
          fontFamily: 'SanFranciscoDisplay',
          fontWeight: fontWeight,
          color: color,
          fontStyle: FontStyle.italic, // 设置字体为斜体
          fontSize: fontSize),
    );
  }


  static double fontSize(BuildContext context, double size) {
    return Constants.screenWidth(context) / 375 * size;
  }
}

/*Preferences key*/
const kUserName = 'nickName';
const kAvatar = 'avatar';
const kAccessToken = 'token';
const kInputEmail = 'inputEmail';
const kUserEmail = 'userEmail';
const kBrithDay = 'brithDay';
const kCountry= 'countryArea';
const kTeam= 'teamName';
const kUnreadMessageCount= 'unreadMessageCount'; // 未读消息的数量

/**蓝牙设备相关的信息**/
const kBLEDevice_Name = 'Myspeedz';
const kBLEDevice_NewName = 'StarShots';
const kFiveBallHandler_Name = 'Stickhandling'; // 五节控球器的名称
const kBLEDevice_OldName = 'Tv511u-E4247823';
const kBLE_SERVICE_NOTIFY_UUID = "ffe0";
const kBLE_SERVICE_WRITER_UUID = "ffe5";
const kBLE_CHARACTERISTIC_NOTIFY_UUID = "ffe4";
const kBLE_CHARACTERISTIC_WRITER_UUID = "ffe9";

const kPageLimit = 10; // 数据分页每页显示的数据量
const kAutoRefreshDuration = 4500; // 游戏自动刷新的时间间隔

const kBLEDevice_Names = [
  kBLEDevice_Name,
  kBLEDevice_NewName,
  kFiveBallHandler_Name
];

const kBLEDataFrameHeader = 0xA5; // 蓝牙数据帧头

const String kBaseUrl_Dev = 'http://120.26.79.141:91'; // 测试环境地址
// 13.49.0.47:91
const String kBaseUrl_Pro = 'http://13.49.0.47:91'; // 生产环境地址

const kDataBaseTableName = 'game_data_table'; // 数据库的表名
const kDataBaseTVideoableName = 'video_table'; // 视频路径数据库的表名

const kGameDuration = 45; // 游戏时常

double kFontSize(BuildContext context, double size) {
  double font =Constants.screenWidth(context) / 375 * size;
  return font;
}

double baseMargin(BuildContext context,double size) {
  double scale =Constants.screenWidth(context) / 375 ;
  return scale*size;
}

//*判断对象是否为空以及字符串长度为0*/
bool ISEmpty(Object? obj) {
  if (obj == null) {
    return true;
  }
  if (obj is String) {
    return obj.length == 0;
  }
  return false;
}

// 全局监听
const kLoginSucess = 'login_success'; // 登录成功
const kFinishGame = 'finish_game'; // 游戏完成，保存数据成功
const kSignOut = 'sign_out'; // 退出登录
const kBackFromFinish = 'back_from_finish'; // 从finish页面返回
const kMessageRead = 'read_message'; // 阅读消息
const kGetMessage = 'get_message'; // 收到消息
const kJuniorGameEnd = 'junior_game_end'; // junior一轮游戏结束

const kTabBarPageChange = 'change_tab_bar_page'; // 底部tabbar切换
const kTabBarPageChangeToRoot= 'change_tab_bar_page_to_root'; //
const kUpdateAvatar = 'update_avatar'; // 切换头像
const kStatsToTracking = 'stats_to_tracking'; // stats页面点击tracking跳转到tracking页面
const kStatsToAccount = 'stats_to_account'; // stats页面点击tracking跳转到account页面

const Map<String,Map<String,String>> kGameSceneAndModelMap = {
  "1" :{
    "7" : "ZIGZAG Challenge",
    "1" : "2 Challenge",
    "2" : "L Challenge",
    "3" : "OMEGA Challenge",
    "6" : "Straight line Challenge",
    "4" : "Pentagon Challenge",
    "5" : "SMILE Challenge",
  },
  "2" :{
    "7" : "ZIGZAG Challenge",
    "1" : "2 Challenge",
    "2" : "L Challenge",
    "3" : "OMEGA Challenge",
    "6" : "Straight line Challenge",
    "4" : "Pentagon Challenge",
    "5" : "SMILE Challenge",
  },
  "3" :{
    "7" : "ZIGZAG Challenge",
    "1" : "2 Challenge",
    "2" : "L Challenge",
    "3" : "OMEGA Challenge",
    "6" : "Straight line Challenge",
    "4" : "Pentagon Challenge",
    "5" : "SMILE Challenge",
  }
};// 游戏场景和模式映射表

const k270ProductImageScale = 1445/737; // 270产品图片宽高比

const  kUserVideoMaxCount = 100; // 视频的最大数量

const kAppVersion = '202405131652';

const kJuniorRedtargets = [2,4,5];
const kJuniorBluetargets = [1,3,6];
const kBattleTargets = [1,2,3,4,5,6];
const Map<int,int> kTargetAndScoreMap = {
  1:11,
  2:25,
  3:9,
  4:13,
  5:23,
  6:9
}; // 标靶和得分映射表