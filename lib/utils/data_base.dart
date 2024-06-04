

import 'package:robot/model/game_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/constants.dart';

class VideoPathModel {
  String id = '';
  String videoPath = '';

  VideoPathModel({required this.id, required this.videoPath});
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Database? _database;
  Database? _videoDatabase;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> get videoDatabase async {
    if (_videoDatabase != null) {
      return _videoDatabase!;
    }
    _videoDatabase = await initVideoDatabase();
    return _videoDatabase!;
  }

  /*游戏数据表*/
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_table.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${kDataBaseTableName}(
        id INTEGER PRIMARY KEY,
        speed TEXT,
        score TEXT,
        indexString TEXT,
        path TEXT,
        createTime TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE ${kDataBaseTVideoableName}(
        id INTEGER PRIMARY KEY,
        videoPath TEXT
      )
    ''');
  }

  /*游戏视频*/
  Future<Database> initVideoDatabase() async {
    String path = join(await getDatabasesPath(), 'my_table.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /*插入游戏数据*/
  Future<int> insertData(String table, Gamemodel data) async {
    Database db = await database;
    print('插入游戏数据=${ data.path}');
    print('插入游戏数据=${ data.toJson}');
    return await db.insert(table, data.toJson());
  }

  /*插入游戏视频路径数据*/
  Future<int> insertVideoData(String table, String data) async {
    Database db = await videoDatabase;
    return await db.insert(table, {"videoPath": data});
  }

  Future<int> updateData(
      String table, Map<String, dynamic> data, int id) async {
      Database db = await database;
      print('更新数据-----');
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(String table, int id) async {
    Database db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

/*删除某条视频路径数据*/
  Future<int> deletevVideoPathData(String table, int id) async {
    Database db = await videoDatabase;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Gamemodel>> getData(String table) async {
    Database db = await database;
    final _datas = await db.rawQuery('SELECT * FROM ${table}');
    List<Gamemodel> array = [];
    _datas.asMap().forEach((index,element) {
      Gamemodel model = Gamemodel.modelFromJson(element);
      model.indexString = (index+1).toString();
      array.add(model);
    });
    return array;
  }

/*获取本地的视频列表*/
  Future<List<VideoPathModel>> getVideoListData(String table) async {
    Database db = await videoDatabase;
    final _datas = await db.query(table);

    List<VideoPathModel> array = [];
    _datas.forEach((element) {
      String videoPath = element['videoPath'].toString();
      String id = element['id'].toString();
      VideoPathModel model = VideoPathModel(id: id, videoPath: videoPath);
      array.add(model);
    });
    return array;
  }

}
