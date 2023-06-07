import 'package:fade_folder_exe/common/style.dart';
import 'package:fade_folder_exe/widgets/custom_button.dart';
import 'package:fade_folder_exe/widgets/custom_text_box.dart';
import 'package:fluent_ui/fluent_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
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
                  const Text(
                    '設定',
                    style: TextStyle(fontSize: 18),
                  ),
                  CustomButton(
                    labelText: '設定内容を保存',
                    labelColor: whiteColor,
                    backgroundColor: greyColor,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InfoLabel(
                label: 'ソフトウェアの起動時、ロックする',
                child: CustomTextBox(
                  placeholder: 'パスワード',
                ),
              ),
              const SizedBox(height: 8),
              InfoLabel(
                label: 'ソフトウェアを一定期間起動しなかった場合、このソフトウェア内に入っているデータを全て削除する',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
