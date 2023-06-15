import 'dart:io';

import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/services/file.dart';
import 'package:fade_folder_exe/services/folder.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FolderFileController {
  FileService fileService = FileService();
  FolderService folderService = FolderService();

  Future start() async {
    await folderService.select();
    await Future.delayed(const Duration(seconds: 2));
  }

  Future allReset() async {
    await allRemovePrefs();
    await folderService.truncate();
    await fileService.truncate();
    final dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/.fade_folder';
    Directory(path).deleteSync(recursive: true);
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<String> upload({
    required int folderId,
    required XFile file,
  }) async {
    final dir = await getApplicationSupportDirectory();
    String path = '${dir.path}/.fade_folder/$folderId';
    //フォルダ作成
    await Directory(path).create(recursive: true);
    path += '/${p.basename(file.path)}';
    File savedFile = File(path);
    await savedFile.writeAsBytes(await file.readAsBytes());
    // if (savedFile.existsSync()) {
    //   //暗号化
    //   final plainText = savedFile.readAsStringSync();
    //   final key = Key.fromUtf8(kEncryptKey);
    //   final iv = IV.fromLength(16);
    //   final encrypt = Encrypter(AES(key));
    //   final encryptedText = encrypt.encrypt(plainText, iv: iv);
    //   final encryptedFile = File('${savedFile.path}.encrypted');
    //   encryptedFile.writeAsStringSync(encryptedText.base64);
    //   path = encryptedFile.path;
    // }
    return path;
  }

  void fileDelete(String path) {
    File(path).deleteSync(recursive: true);
  }

  Future delete(int id) async {
    final dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/.fade_folder/$id';
    Directory(path).deleteSync(recursive: true);
  }
}
