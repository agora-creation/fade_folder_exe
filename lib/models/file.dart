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
}
