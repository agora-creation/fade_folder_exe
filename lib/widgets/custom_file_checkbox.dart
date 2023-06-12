import 'package:fluent_ui/fluent_ui.dart';

class CustomFileCheckbox extends StatelessWidget {
  final bool checked;
  final Function(bool?) onChanged;

  const CustomFileCheckbox({
    required this.checked,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Checkbox(
        checked: checked,
        onChanged: onChanged,
      ),
    );
  }
}
