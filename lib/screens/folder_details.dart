import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/models/folder.dart';
import 'package:fade_folder_exe/widgets/custom_icon_button.dart';
import 'package:fluent_ui/fluent_ui.dart';

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
                      CustomIconButton(
                        iconData: FluentIcons.edit,
                        iconColor: blackColor,
                        backgroundColor: blueColor,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4),
                      CustomIconButton(
                        iconData: FluentIcons.delete,
                        iconColor: blackColor,
                        backgroundColor: redColor,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
