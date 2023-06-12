import 'package:fade_folder_exe/models/file.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

class CustomFileCard extends StatelessWidget {
  final FileModel file;
  final Function()? onTap;
  final List<Widget> children;

  const CustomFileCard({
    required this.file,
    required this.onTap,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        padding: EdgeInsets.zero,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        child: FutureBuilder<Uint8List>(
          future: file.getFileData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(snapshot.requireData),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: children,
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
