import 'package:fade_folder_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomFileLabel extends StatelessWidget {
  final String text;

  const CustomFileLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor.withOpacity(0.6),
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        style: const TextStyle(
          color: whiteColor,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
