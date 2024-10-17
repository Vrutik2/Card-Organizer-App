import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const folder = 'table';
  static const cards = 'cards';
  static const cardId = '_id';
  static const folderId = '_id';
  static const columnNum = 'num';
  static const columnSuit = 'suit';
  static const name = 'name';
  static const folderName = 'folderName';
  static const foreignId = 'folderKey';

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

// SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $folder (
      $folderId INTEGER PRIMARY KEY
      $columnSuit TEXT NOT NULL
      $folderName TEXT NOT NULL
      )
    ''');
    await db.execute('''
      create table $cards (
      $cardId INTEGER PRIMARY KEY
      $columnNum INTEGER NOT NULL
      $name TEXT NOT NULL
      $folderId FOREIGN KEY
      )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(folder, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(folder);
  }

  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $folder');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[folderId];
    return await _db.update(
      folder,
      row,
      where: '$folderId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      cards,
      where: '$folderId = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertC(Map<String, dynamic> row) async {
    return await _db.insert(cards, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRowsC() async {
    return await _db.query(cards);
  }

  Future<int> queryRowCountC() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $cards');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> updateC(Map<String, dynamic> row) async {
    int id = row[cardId];
    return await _db.update(
      cards,
      row,
      where: '$cardId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteC(int id) async {
    return await _db.delete(
      cards,
      where: '$cardId = ?',
      whereArgs: [id],
    );
  }
}