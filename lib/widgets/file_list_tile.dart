import 'package:fade_folder_exe/common/style.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;

class FileListTile extends StatelessWidget {
  final XFile file;

  const FileListTile({
    required this.file,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: grey2Color)),
      ),
      child: ListTile(
        title: Text(p.basename(file.path)),
      ),
    );
  }
}
