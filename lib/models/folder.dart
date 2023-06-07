class FolderModel {
  int? id;
  String name;
  DateTime? createdAt;

  FolderModel({
    this.id,
    required this.name,
    this.createdAt,
  });

  factory FolderModel.fromSQLite(Map map) {
    return FolderModel(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.tryParse(map['createdAt']),
    );
  }

  static List<FolderModel> fromSQLiteList(List<Map> listMap) {
    List<FolderModel> ret = [];
    for (Map map in listMap) {
      ret.add(FolderModel.fromSQLite(map));
    }
    return ret;
  }

  factory FolderModel.empty() {
    return FolderModel(name: '');
  }
}
