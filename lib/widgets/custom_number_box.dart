import 'package:fluent_ui/fluent_ui.dart';

class CustomNumberBox extends StatelessWidget {
  final int? value;
  final Function(int?)? onChanged;

  const CustomNumberBox({
    this.value,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NumberBox<int>(
      value: value,
      onChanged: onChanged,
      mode: SpinButtonPlacementMode.inline,
    );
  }
}
