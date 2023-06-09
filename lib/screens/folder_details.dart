import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/models/file.dart';
import 'package:fade_folder_exe/models/folder.dart';
import 'package:fade_folder_exe/screens/file_details.dart';
import 'package:fade_folder_exe/services/file.dart';
import 'package:fade_folder_exe/services/folder.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:fade_folder_exe/widgets/custom_file_card.dart';
import 'package:fade_folder_exe/widgets/custom_icon_button.dart';
import 'package:fade_folder_exe/widgets/custom_text_box.dart';
import 'package:fade_folder_exe/widgets/file_list_tile.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FolderDetailsScreen extends StatefulWidget {
  final FolderModel folder;
  final Function() init;

  const FolderDetailsScreen({
    required this.folder,
    required this.init,
    super.key,
  });

  @override
  State<FolderDetailsScreen> createState() => _FolderDetailsScreenState();
}

class _FolderDetailsScreenState extends State<FolderDetailsScreen> {
  FileService fileService = FileService();
  List<FileModel> files = [];
  List<int> checked = [];

  void _getFiles() async {
    List<FileModel> tmpFiles = await fileService.select(
      folderId: widget.folder.id ?? 0,
    );
    if (mounted) {
      setState(() {
        files = tmpFiles;
      });
    }
  }

  void _check(int value) {
    setState(() {
      if (checked.contains(value)) {
        checked.remove(value);
      } else {
        checked.add(value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.folder.name,
                  style: const TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    checked.isNotEmpty
                        ? CustomButton(
                            labelText: '選択したファイルを削除する',
                            labelColor: whiteColor,
                            backgroundColor: redColor,
                            onPressed: () async {
                              for (int id in checked) {
                                await fileService.delete(id: id);
                              }
                              _getFiles();
                            },
                          )
                        : Container(),
                    CustomIconButton(
                      iconData: FluentIcons.more_vertical,
                      iconColor: blackColor,
                      backgroundColor: whiteColor,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => EditFolderDialog(
                          folder: widget.folder,
                          init: widget.init,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              'ファイルをドラッグ&ドロップしてください。',
              style: TextStyle(
                color: greyColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DropTarget(
                onDragDone: (value) => showDialog(
                  context: context,
                  builder: (context) => AddFileDialog(
                    folder: widget.folder,
                    files: value.files,
                    getFiles: _getFiles,
                  ),
                ),
                child: files.isNotEmpty
                    ? SingleChildScrollView(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: files.length,
                          gridDelegate: kGridSetting,
                          itemBuilder: (context, index) {
                            int id = files[index].id ?? 0;
                            String path = files[index].path;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FluentPageRoute(
                                    builder: (context) => FileDetailsScreen(
                                      file: files[index],
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: CustomFileCard(
                                file: files[index],
                                children: [
                                  Checkbox(
                                    checked: checked.contains(id),
                                    onChanged: (value) {
                                      _check(id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox(
                        width: double.infinity,
                        child: Center(child: Text('ファイルがありません')),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditFolderDialog extends StatefulWidget {
  final FolderModel folder;
  final Function() init;

  const EditFolderDialog({
    required this.folder,
    required this.init,
    super.key,
  });

  @override
  State<EditFolderDialog> createState() => _EditFolderDialogState();
}

class _EditFolderDialogState extends State<EditFolderDialog> {
  FolderService folderService = FolderService();
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.folder.name;
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'フォルダ編集',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: 'フォルダ名',
            child: CustomTextBox(
              controller: name,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: '削除する',
          labelColor: whiteColor,
          backgroundColor: redColor,
          onPressed: () async {
            String? error = await folderService.delete(
              id: widget.folder.id ?? 0,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.init();
            if (!mounted) return;
            showMessage(context, '削除しました', true);
            Navigator.pop(context);
          },
        ),
        CustomButton(
          labelText: '保存する',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () async {
            String? error = await folderService.update(
              id: widget.folder.id ?? 0,
              name: name.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.init();
            if (!mounted) return;
            showMessage(context, '保存しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class AddFileDialog extends StatefulWidget {
  final FolderModel folder;
  final List<XFile> files;
  final Function() getFiles;

  const AddFileDialog({
    required this.folder,
    required this.files,
    required this.getFiles,
    super.key,
  });

  @override
  State<AddFileDialog> createState() => _AddFileDialogState();
}

class _AddFileDialogState extends State<AddFileDialog> {
  FileService fileService = FileService();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(
        '${widget.files.length}個のファイルを選択中',
        style: const TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.files.map((file) {
            return FileListTile(file: file);
          }).toList(),
        ),
      ),
      actions: [
        CustomButton(
          labelText: 'キャンセル',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'アップロードする',
          labelColor: whiteColor,
          backgroundColor: blueColor,
          onPressed: () async {
            final dir = await getApplicationDocumentsDirectory();
            if (widget.files.isNotEmpty) {
              for (XFile file in widget.files) {
                int folderId = widget.folder.id ?? 0;
                String savedPath = '${dir.path}/fade_folder/$folderId';
                await Directory(savedPath).create(recursive: true);
                savedPath += '/${p.basename(file.path)}';
                File savedFile = File(savedPath);
                await savedFile.writeAsBytes(await file.readAsBytes());
                await fileService.insert(
                  folderId: folderId,
                  path: savedPath,
                );
              }
            }
            await widget.getFiles();
            if (!mounted) return;
            showMessage(context, 'ファイルをアップロードしました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
