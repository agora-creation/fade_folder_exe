import 'package:fade_folder_exe/common/style.dart';
import 'package:fluent_ui/fluent_ui.dart';

class CustomBorderTitle extends StatelessWidget {
  final String text;

  const CustomBorderTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: blackColor)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
