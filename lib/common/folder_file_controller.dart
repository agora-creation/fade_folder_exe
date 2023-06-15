import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/services/file.dart';
import 'package:fade_folder_exe/services/folder.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FolderFileController {
  static final myKey = enc.Key.fromUtf8('xWaCuj1t8GoEFBtl8ReSIfVM0QHcfAA5');
  static final myIv = enc.IV.fromUtf8('dtctVyn0wbSTkBAp');
  static final myEncrypter = enc.Encrypter(enc.AES(myKey));
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
    String savedPath = '${dir.path}/.fade_folder/$folderId';
    String savedFileName = p.basename(file.path);
    if (!await Directory(savedPath).exists()) {
      await Directory(savedPath).create(recursive: true);
    }
    //暗号化
    // Uint8List orgData = await file.readAsBytes();
    // final encrypted = myEncrypter.encryptBytes(orgData, iv: myIv);
    // File savedFile = File('$savedPath/$savedFileName.aes');
    // await savedFile.writeAsBytes(encrypted.bytes);
    return '$savedPath/$savedFileName';
  }

  Future _getFile(String path) async {
    File f = File(path);
    Uint8List bytes = await f.readAsBytes();
    enc.Encrypted en = enc.Encrypted(bytes);
    var plainData = myEncrypter.decryptBytes(en, iv: myIv);
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
