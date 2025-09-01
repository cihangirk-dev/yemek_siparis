import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'yemekler.sqlite');

    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load('assets/veritabani/yemekler.sqlite');
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }

    _database = await openDatabase(path, readOnly: false);
    return _database!;
  }
}
