import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomFileButton extends StatelessWidget {
  final XFile? file;
  final Function()? onPressed;

  const CustomFileButton({
    this.file,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomButton(
          labelText: 'ファイル選択',
          labelColor: blackColor,
          backgroundColor: grey2Color,
          onPressed: onPressed,
        ),
        const SizedBox(height: 4),
        file != null
            ? Text(
                '${file?.name}',
                overflow: TextOverflow.ellipsis,
              )
            : Container(),
      ],
    );
  }
}
