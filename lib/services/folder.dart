import 'package:fade_folder_exe/models/folder.dart';
import 'package:fade_folder_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FolderService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future<List<FolderModel>> select() async {
    try {
      Database db = await _getDatabase();
      List<Map> listMap = await db.rawQuery('select * from folder');
      return FolderModel.fromSQLiteList(listMap);
    } catch (e) {
      throw Exception();
    }
  }

  Future<String?> insert({required String name}) async {
    String? error;
    if (name == '') return 'フォルダ名を入力してください';
    try {
      Database db = await _getDatabase();
      int id = await db.rawInsert('''
        insert into folder (
          name
        ) values (
          '$name'
        );
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> update({
    required int id,
    required String name,
  }) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawUpdate('''
        update folder
        set name = '$name'
        where id = $id;
      ''');
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> delete({required int id}) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawDelete(
        'delete from folder where id = $id;',
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }
}
