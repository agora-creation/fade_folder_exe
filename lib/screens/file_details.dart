import 'dart:io';

import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/models/file.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;

class FileDetailsScreen extends StatelessWidget {
  final FileModel file;

  const FileDetailsScreen({
    required this.file,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      header: Container(
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(FluentIcons.back, color: whiteColor),
                onPressed: () => Navigator.pop(context),
              ),
              IconButton(
                icon: const Icon(FluentIcons.download, color: whiteColor),
                onPressed: () async {
                  final data = await File(file.path).readAsBytes();
                  String? path = await getSavePath(
                    acceptedTypeGroups: [
                      const XTypeGroup(
                        label: '全てのファイル',
                        extensions: ['*'],
                      )
                    ],
                    suggestedName: p.basename(file.path),
                  );
                  if (path == null) return;
                  final xFile = XFile.fromData(data);
                  await xFile.saveTo(path);
                },
              ),
            ],
          ),
        ),
      ),
      content: Center(
        child: Image.file(
          File(file.path),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
