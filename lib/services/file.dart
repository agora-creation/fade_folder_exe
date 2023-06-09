import 'package:fade_folder_exe/models/file.dart';
import 'package:fade_folder_exe/services/connection_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class FileService {
  ConnectionSQLiteService connection = ConnectionSQLiteService.instance;

  Future<Database> _getDatabase() async {
    return await connection.db;
  }

  Future<List<FileModel>> select({
    required int folderId,
  }) async {
    try {
      Database db = await _getDatabase();
      String sql = 'select * from file where folderId = $folderId';
      sql += ' order by createdAt DESC';
      List<Map> listMap = await db.rawQuery(sql);
      return FileModel.fromSQLiteList(listMap);
    } catch (e) {
      throw Exception();
    }
  }

  Future<String?> insert({
    required int folderId,
    required String path,
  }) async {
    String? error;
    try {
      Database db = await _getDatabase();
      await db.rawInsert('''
        insert into file (
          folderId,
          path
        ) values (
          $folderId,
          '$path'
        );
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
        'delete from file where id = $id;',
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future truncate() async {
    Database db = await _getDatabase();
    await db.delete('file');
  }
}
