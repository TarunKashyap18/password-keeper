import 'dart:convert';
import 'dart:io';
import 'package:password_keeper/model/item.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper()=> _instance;
  final String  tableName= "passwordKeeper";
  final String  columnId= "id";
  final String  columnAppName= "appName";
  final String  columnData= "data";
  final String  columnDateAdded= "dateAdded";

  static Database _db;

  Future<Database> get db async{
    if(_db !=null)
      return _db;

    _db = await initDb();
    return _db;
  }
  DatabaseHelper.internal();

  initDb() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"password_keeper1.db");
    var myDb = await openDatabase(path,version: 1,onCreate: _onCreate);
    return myDb;
  }
  void _onCreate(Database db,int version)async{
    String sql="CREATE TABLE $tableName(id INTEGER PRIMARY KEY,$columnAppName TEXT,$columnData TEXT,$columnDateAdded)";
    await db.execute(sql);
    print("Table is created");
  }
  //  insert data
  Future<int> saveItem(Item item) async{
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  String decodeData(String data){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded = stringToBase64.decode(data);
    print(decoded);
    return decoded;
  }
  //get data
  Future<List> getItems()async{
      String sql="SELECT * FROM $tableName ORDER BY $columnAppName ASC";
      var dbClient = await db;
      var result= await dbClient.rawQuery(sql);
      return result.toList();
  }
  Future<Item> getItem(int id)async{
      String sql="SELECT * FROM $tableName WHERE id = $id";
      var dbClient = await db;
      var result= await dbClient.rawQuery(sql);
      if(result.length == 0)
        return null;
      return new Item.fromMap(result.first);
  }
//  get count
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "$columnId = ?", whereArgs: [id]);

  }
  Future<int> updateItem(Item item) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);

  }
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}