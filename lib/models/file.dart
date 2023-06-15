import 'dart:io';

import 'package:flutter/services.dart';

class FileModel {
  int? id;
  int folderId;
  String path;
  DateTime? createdAt;

  FileModel({
    this.id,
    required this.folderId,
    required this.path,
    this.createdAt,
  });

  factory FileModel.fromSQLite(Map map) {
    return FileModel(
      id: map['id'],
      folderId: map['folderId'],
      path: map['path'],
      createdAt: DateTime.tryParse(map['createdAt']),
    );
  }

  static List<FileModel> fromSQLiteList(List<Map> listMap) {
    List<FileModel> ret = [];
    for (Map map in listMap) {
      ret.add(FileModel.fromSQLite(map));
    }
    return ret;
  }

  factory FileModel.empty() {
    return FileModel(
      folderId: 0,
      path: '',
    );
  }

  Future<Uint8List> getFileData() async {
    File f = File(path);
    //復号化
    // Uint8List encData = await f.readAsBytes();
    // enc.Encrypted en = enc.Encrypted(encData);
    // var plainData = FolderFileController.myEncrypter.decryptBytes(
    //   en,
    //   iv: FolderFileController.myIv,
    // );
    return await f.readAsBytes();
  }
}
