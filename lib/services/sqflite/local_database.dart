// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/models/bluetooth_printer_dto.dart';

class LocalDatabase {
  static late Database _database;
  static const String DATABASE_NAME = 'VietQR.db';
  static const String PRINTER_TABLE = 'PrinterTable';

  const LocalDatabase._privateConstructor();

  static const LocalDatabase _instance = LocalDatabase._privateConstructor();
  static LocalDatabase get instance => _instance;

  Future<Database> get database async {
    _database = await initialDatabase();
    return _database;
  }

  Future<Database> initialDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DATABASE_NAME);
    // print('path DB: $path');
    Database database =
        await openDatabase(path, version: 2, onCreate: _onCreate);
    return database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $PRINTER_TABLE (id PRIMARYKEY TEXT, name TEXT, address TEXT, userId TEXT)');
  }

  Future<void> close() async {
    var dbClient = await database;
    dbClient.close();
  }

  ///
  ///
  //PRINTER
  ///
  //get
  Future<BluetoothPrinterDTO> getBluetoothPrinter(String userId) async {
    BluetoothPrinterDTO result =
        const BluetoothPrinterDTO(id: '', name: '', address: '', userId: '');
    try {
      Database dbClient = await database;
      var response = await dbClient.rawQuery(
          "SELECT * FROM $PRINTER_TABLE WHERE userId = '$userId' LIMIT 1");
      if (response.isNotEmpty) {
        result = BluetoothPrinterDTO.fromJson(response.first);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  //insert
  Future<void> insertBluetoothPrinter(BluetoothPrinterDTO dto) async {
    try {
      Database dbClient = await database;
      await dbClient.insert(PRINTER_TABLE, dto.toJson());
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  //delete
  Future<void> deleteBluetoothPrinter(String userId) async {
    try {
      Database dbClient = await database;
      dbClient.rawQuery("DELETE FROM $PRINTER_TABLE WHERE userId = '$userId'");
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  //update
  Future<void> updateBluetoothPrinter(BluetoothPrinterDTO dto) async {
    try {
      Database dbClient = await database;
      dbClient.rawQuery(
        "UPDATE $PRINTER_TABLE SET name = ?, address = ? WHERE userId = ?",
        [dto.name, dto.address, dto.userId],
      );
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
