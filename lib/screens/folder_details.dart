import 'dart:io';

import 'package:fade_folder_exe/common/functions.dart';
import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/models/file.dart';
import 'package:fade_folder_exe/models/folder.dart';
import 'package:fade_folder_exe/services/file.dart';
import 'package:fade_folder_exe/services/folder.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:fade_folder_exe/widgets/custom_file_button.dart';
import 'package:fade_folder_exe/widgets/custom_file_card.dart';
import 'package:fade_folder_exe/widgets/custom_icon_button.dart';
import 'package:fade_folder_exe/widgets/custom_text_box.dart';
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
      child: SingleChildScrollView(
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
                      CustomButton(
                        labelText: 'アップロード',
                        labelColor: whiteColor,
                        backgroundColor: blueColor,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AddFileDialog(
                            folder: widget.folder,
                            getFiles: _getFiles,
                          ),
                        ),
                      ),
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
              const SizedBox(height: 16),
              files.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      itemCount: files.length,
                      gridDelegate: kGridSetting,
                      itemBuilder: (context, index) {
                        int id = files[index].id ?? 0;
                        String path = files[index].path;
                        return CustomFileCard(
                          file: files[index],
                          children: [
                            Checkbox(
                              checked: checked.contains(id),
                              onChanged: (value) {
                                _check(id);
                              },
                            ),
                          ],
                        );
                      },
                    )
                  : const Text('ファイルがありません'),
            ],
          ),
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
  final Function() getFiles;

  const AddFileDialog({
    required this.folder,
    required this.getFiles,
    super.key,
  });

  @override
  State<AddFileDialog> createState() => _AddFileDialogState();
}

class _AddFileDialogState extends State<AddFileDialog> {
  FileService fileService = FileService();
  XFile? file;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: const Text(
        'アップロード',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFileButton(
            file: file,
            onPressed: () async {
              XTypeGroup group = const XTypeGroup(
                label: '全てのファイル',
                extensions: ['*'],
              );
              XFile? tmpFile = await openFile(acceptedTypeGroups: [group]);
              if (tmpFile != null) {
                setState(() {
                  file = tmpFile;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        CustomButton(
          labelText: 'いいえ',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          labelText: 'はい',
          labelColor: whiteColor,
          backgroundColor: greyColor,
          onPressed: () async {
            if (file == null) return;
            final dir = await getApplicationDocumentsDirectory();
            String savedPath = '${dir.path}/${p.basename(file!.path)}';
            File savedFile = File(savedPath);
            await savedFile.writeAsBytes(await file!.readAsBytes());
            await fileService.insert(
              folderId: widget.folder.id ?? 0,
              path: savedPath,
            );
            widget.getFiles();
            if (!mounted) return;
            showMessage(context, 'データを追加しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
