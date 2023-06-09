import 'dart:io';

import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/models/file.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class CustomFileCard extends StatefulWidget {
  final FileModel file;
  final List<Widget> children;

  const CustomFileCard({
    required this.file,
    required this.children,
    super.key,
  });

  @override
  State<CustomFileCard> createState() => _CustomFileCardState();
}

class _CustomFileCardState extends State<CustomFileCard> {
  Uint8List? fileData;

  void _init() async {
    Uint8List tmpFileData = await File(widget.file.path).readAsBytes();
    setState(() {
      fileData = tmpFileData;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: EdgeInsets.zero,
      borderColor: blackColor,
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      child: Container(
        decoration: BoxDecoration(
          image: fileData != null
              ? DecorationImage(
                  image: MemoryImage(
                    fileData!,
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
