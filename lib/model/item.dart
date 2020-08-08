import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:convert/convert.dart';

class Item extends StatelessWidget {
  String _appName;
  String _data;
  String _dateAdded;
  int _id;

  Item(this._appName,this._data, this._dateAdded);

  String encodeData(String data){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(data);
    print(encoded);
    return encoded;
  }
  String decodeData(String data){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String decoded = stringToBase64.decode(data);
    print(decoded);
    return decoded;
  }

  Item.map(dynamic obj){
    this._appName = obj["appName"];
    this._data=obj["data"];
    this._dateAdded = obj["dateAdded"];
    this._id = obj["id"];
  }

  String get appName => _appName;
  String get data => _data;
  String get dateAdded => _dateAdded;
  int get id => _id;

  Map<String, dynamic> toMap(){
    var map =new Map<String, dynamic>();
    map["appName"]= _appName;
    map["data"]=_data;
    map["dateAdded"]= _dateAdded;
    if(_id!=null){
      map["id"]=_id;
    }
    return map;
  }

  Item.fromMap(Map<String,dynamic>map){
    this._appName = map["appName"];
    this._data =map["data"];
    this._dateAdded= map["dateAdded"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_appName,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9
            ),),
          Text(_data,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9
            ),),

          Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: Text(
              "Created on ${_dateAdded}",
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13.5,
                  fontStyle: FontStyle.italic
              ) ,
            ),
          )
        ],
      ),
    );
  }
}
