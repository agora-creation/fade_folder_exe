import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FolderController {
  Future<String> upload(int id, XFile file) async {
    final dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/.fade_folder/$id';
    await Directory(path).create(recursive: true);
    path += '/${p.basename(file.path)}';
    File savedFile = File(path);
    await savedFile.writeAsBytes(await file.readAsBytes());
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

  Future allDelete() async {
    final dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/.fade_folder';
    Directory(path).deleteSync(recursive: true);
  }
}
