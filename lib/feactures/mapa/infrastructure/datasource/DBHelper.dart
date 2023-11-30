import 'dart:io';

import 'package:location_grm/feactures/core/constans/constants.dart';
import 'package:location_grm/feactures/mapa/infrastructure/models/solicitud.dart';
import 'package:location_grm/feactures/mapa/infrastructure/models/usuario.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DBHelper{
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  DBHelper._privateConstructor();

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'info.db';
    final path = await getDatabasesPath();
    return join(path,name);
  }

  Future<Database> _initialize() async{
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {

      await db.execute(
        'CREATE TABLE solicitudes('
            'id TEXT PRIMARY KEY, '
            'data TEXT, estado INTEGER'
            ')',
      );

      await db.execute(
        'CREATE TABLE users('
            'ci TEXT PRIMARY KEY, '
            'password TEXT, '
            'full_name TEXT, '
            'phone INTEGER, '
            'sex TEXT, '
            'birthdate TEXT, '
            'blood_group TEXT, '
            'assurance TEXT)',
      );
    },
      singleInstance: true,);
    return database;
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      '$user_table',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('user inserted');
  }

  Future<void> deleteUser(String ci) async {
    final db = await database;
    await db.delete(
      '$user_table',
      where: 'ci = ?',
      whereArgs: [ci],
    );
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<bool> checkIfUserExists() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      '$user_table',
      limit: 1,  // Limit the query to a single result
    );

    return result.isNotEmpty;
  }
  Future<Map<String, dynamic>> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      '$user_table',
      limit: 1,  // Limit the query to a single result
    );

    return result[0];
  }


  Future<void> insertSolicitud(Solicitud solicitud) async {

    final db = await database;
    await db.insert(
      '$request_table',
      solicitud.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSolicitud(Solicitud solicitud) async {
    final db = await database;
    await db.update(
      '$request_table',
      solicitud.toMap(),
      where: 'id = ?',
      whereArgs: [solicitud.id],
    );
  }

  Future<List<Solicitud>> getAllSolicitud() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('$request_table');

    return List.generate(maps.length, (i) {
      return Solicitud.fromMap(maps[i]);
    });
  }

  Future<List<Solicitud>> getPendingSolicitudes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'solicitudes',
      where: 'estado = ?',
      whereArgs: [Status.pendiente.index], // Assuming Status.pendiente is an enum
    );

    // Convert the List<Map<String, dynamic>> to a List<Solicitud>
    return List.generate(maps.length, (i) {
      return Solicitud(
        id: maps[i]['id'],
        data: maps[i]['data'],
        estado: Status.values[maps[i]['estado']],
      );
    });
  }


  Future<void> deleteTable(String tableName) async {
    final db = await database;
    await db.delete(tableName);
    print('Todos los registros de $tableName han sido eliminados.');
  }

  Future<void> deleteDatabases() async {
      // 获取数据库路径
      String databasePath = await getDatabasesPath();

      // 删除数据库文件
      File databaseFile = File(databasePath);
      if (await databaseFile.exists()) {
        databaseFile.delete();
      }

    print('Base de datos eliminada');
  }
}